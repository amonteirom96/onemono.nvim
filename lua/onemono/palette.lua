local util = require("onemono.util")

local M = {}

--- Base palettes, taken from the Onedark family (sainnhe/edge). Everything
--- else is derived from these nine colors.
--- `fg` is the color used for code. Only strings (green) and functions (blue)
--- get a hue, the two Onedark colors that read as calm, not as alarm.
--- There is no purple or pink, and `red` means *error* and nothing else
--- (diagnostics, error messages, FIXME, git deletions).
---@type table<"light"|"dark", onemono.BasePalette>
M.base = {
  light = {
    bg = "#eef2f8", -- essential light: paper leaning to a soft, cool blue
    fg = "#4b505b", -- edge light: soft graphite
    -- Accents keep edge light's hue and saturation, darkened just enough to
    -- pass WCAG AA on bg and surface2.
    red = "#b33c3c",
    orange = "#9b5522",
    yellow = "#8c5d04",
    green = "#4d7128",
    cyan = "#2f716b",
    azure = "#545dc0",
    blue = "#3f67a9",
  },
  dark = {
    bg = "#2c2e34", -- edge dark: onedark gray
    fg = "#c5cdd9", -- edge dark: cool off-white
    red = "#f5898e",
    orange = "#e0a06e",
    yellow = "#deb974",
    green = "#a0c980",
    cyan = "#5dbbc1",
    azure = "#96a8ee",
    blue = "#6cb6eb",
  },
}

---@class onemono.BasePalette
---@field bg string
---@field fg string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field cyan string
---@field azure string
---@field blue string

---@class onemono.Colors: onemono.BasePalette
---@field variant "light"|"dark"
---@field none "NONE"
---@field bg_float string
---@field bg_dim string      background for inactive windows (dim_inactive)
---@field surface1 string    cursorline, subtle rows
---@field surface2 string    selection, active tab, statusline
---@field surface3 string    stronger selection / match paren
---@field border string
---@field muted string       UI chrome only (line numbers, whitespace) — never code
---@field accent string      single UI focal color (matches, prompts)
---@field search string      background for search matches
---@field code { string: string, func: string }  the only hues used in code
---@field git { add: string, change: string, delete: string }
---@field diag { error: string, warn: string, info: string, hint: string, ok: string }

--- Build the full, derived color table for a variant.
---@param variant "light"|"dark"
---@param opts onemono.Config
---@return onemono.Colors
function M.get(variant, opts)
  local b = vim.deepcopy(M.base[variant])
  local c = b --[[@as onemono.Colors]]
  local is_light = variant == "light"
  local blend = util.blend

  c.variant = variant
  c.none = "NONE"

  -- UI surfaces lean slightly blue, like edge's bg1..bg4. Alphas are tuned to
  -- land on those values.
  local tint = blend(c.azure, c.fg, 0.5)
  c.surface1 = blend(tint, c.bg, is_light and 0.05 or 0.06)
  c.surface2 = blend(tint, c.bg, is_light and 0.08 or 0.085)
  c.surface3 = blend(tint, c.bg, is_light and 0.14 or 0.13)
  c.border = blend(tint, c.bg, is_light and 0.24 or 0.22)
  c.muted = blend(c.fg, c.bg, is_light and 0.64 or 0.50)
  c.bg_dim = is_light and blend(c.fg, c.bg, 0.03) or util.darken(c.bg, 0.12)
  c.bg_float = c.bg
  c.accent = c.blue
  -- Tinted accent, same hue family as the UI so it stays clean. Stronger than
  -- surface3 so it reads apart from Visual.
  c.search = blend(c.accent, c.bg, is_light and 0.25 or 0.32)

  local mono = opts.mono
  c.code = { string = mono and c.fg or c.green, func = mono and c.fg or c.blue }
  c.git = { add = c.green, change = c.blue, delete = c.red }
  c.diag = { error = c.red, warn = c.yellow, info = c.blue, hint = c.cyan, ok = c.green }

  if opts.on_colors then
    opts.on_colors(c, variant)
  end
  return c
end

return M
