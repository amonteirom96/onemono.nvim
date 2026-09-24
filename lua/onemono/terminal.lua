local util = require("onemono.util")

local M = {}

--- ANSI 16-color table derived from the palette. Used by `:terminal` and by the
--- ghostty/kitty extras, so the editor and the terminal always match.
--- The palette has no purple, so ANSI magenta uses azure (a violet-leaning
--- blue): programs that pick magenta still get a distinct, calm color.
---@param c onemono.Colors
---@return string[] 0-indexed colors
function M.ansi(c)
  local light = c.variant == "light"
  local bright = light and function(x)
    return util.darken(x, 0.12)
  end or function(x)
    return util.lighten(x, 0.14)
  end

  return {
    [0] = light and c.fg or c.surface3,
    c.red,
    c.green,
    c.yellow,
    c.blue,
    c.azure,
    c.cyan,
    light and c.surface3 or c.fg,
    c.muted,
    bright(c.red),
    bright(c.green),
    bright(c.yellow),
    bright(c.blue),
    bright(c.azure),
    bright(c.cyan),
    light and c.bg or util.lighten(c.fg, 0.4),
  }
end

return M
