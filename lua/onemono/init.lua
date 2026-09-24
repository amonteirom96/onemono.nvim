---@class onemono
local M = {}

--- Bump to invalidate every user's compiled cache after changing highlights.
M.version = "1.3.0"

local cache_dir = vim.fn.stdpath("cache") .. "/onemono"
local configured = false
local key ---@type string?

---@param opts? onemono.Config
function M.setup(opts)
  require("onemono.config").set(opts)
  configured = true
  key = nil
end

---@return onemono.Config
local function options()
  return require("onemono.config").options
end

---@return string
local function cache_key()
  if not key then
    key = configured and require("onemono.config").hash() or ("default-" .. M.version)
  end
  return key
end

---@param name string
---@return onemono.Variant
local function resolve_variant(name)
  if name == "onemono-light" then
    return "light"
  elseif name == "onemono-dark" then
    return "dark"
  end
  local v = options().variant
  if v == "light" or v == "dark" then
    return v
  end
  return vim.o.background == "light" and "light" or "dark"
end

--- Full palette (base + derived) for a variant, after `on_colors`.
---@param variant? onemono.Variant defaults to the current 'background'
---@return onemono.Colors
function M.colors(variant)
  return require("onemono.palette").get(variant or resolve_variant("onemono"), options())
end

--- Final highlight table for a variant, after `on_highlights`.
---@param variant? onemono.Variant
---@return table<string, onemono.Style>
function M.highlights(variant)
  local o = options()
  return require("onemono.groups").get(M.colors(variant), o)
end

---@param name string
---@param variant onemono.Variant
---@return string
local function build(name, variant)
  local o = options()
  local c = require("onemono.palette").get(variant, o)
  local hl = require("onemono.groups").get(c, o)
  local term = o.terminal_colors and require("onemono.terminal").ansi(c) or nil
  return require("onemono.compiler").source(name, variant, hl, term)
end

---@param prefix string
---@param keep string
local function prune(prefix, keep)
  for file in vim.fs.dir(cache_dir) do
    if vim.startswith(file, prefix) and file ~= keep then
      os.remove(cache_dir .. "/" .. file)
    end
  end
end

--- Entry point used by `colors/*.lua`.
---@param name? "onemono"|"onemono-light"|"onemono-dark"
function M.load(name)
  name = name or "onemono"
  local variant = resolve_variant(name)

  if not options().cache then
    return assert(load(build(name, variant), "=onemono"))()
  end

  local prefix = name .. "_" .. variant .. "_"
  local file = prefix .. cache_key()
  local path = cache_dir .. "/" .. file
  local fn = loadfile(path)
  if not fn then
    fn = require("onemono.compiler").write(build(name, variant), path)
    prune(prefix, file)
  end
  fn()
end

--- Rebuild the cache for the active colorscheme (e.g. after editing an
--- `on_highlights` closure whose upvalues changed).
function M.compile()
  M.clear_cache()
  local name = vim.g.colors_name
  if name and vim.startswith(name, "onemono") then
    vim.cmd.colorscheme(name)
  end
end

function M.clear_cache()
  vim.fn.delete(cache_dir, "rf")
  key = nil
end

--- Generate terminal/tool themes (ghostty, kitty, lazygit) from the palette.
---@param dir? string output directory, defaults to `<plugin>/extras`
function M.extras(dir)
  return require("onemono.extras").generate(dir)
end

return M
