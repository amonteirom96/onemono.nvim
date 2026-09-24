--- Code is monochrome: every token uses `fg`, except strings (green) and
--- functions (blue). Structure comes from style (italic/bold, configurable via
--- `styles`), never from extra hues. Red appears only on errors.

---@param c onemono.Colors
---@param o onemono.Config
return function(c, o)
  local s = o.styles
  local fg = c.fg
  local comment = vim.tbl_extend("force", { fg = o.muted_comments and c.muted or fg }, s.comments)

  ---@param style onemono.Style
  ---@param color? string
  local function with(style, color)
    return vim.tbl_extend("force", { fg = color or fg }, style)
  end

  local keyword = with(s.keywords)
  local func = with(s.functions, c.code.func)
  local variable = with(s.variables)
  local str = with(s.strings, c.code.string)
  local typ = with(s.types)
  local const = with(s.constants)
  local op = with(s.operators)

  return {
    Comment = comment,
    SpecialComment = comment,

    Constant = const,
    String = str,
    Character = str,
    Number = const,
    Boolean = const,
    Float = const,

    Identifier = variable,
    Function = func,

    Statement = keyword,
    Conditional = keyword,
    Repeat = keyword,
    Label = keyword,
    Keyword = keyword,
    Exception = keyword,
    Operator = op,

    PreProc = keyword,
    Include = keyword,
    Define = keyword,
    Macro = keyword,
    PreCondit = keyword,

    Type = typ,
    StorageClass = keyword,
    Structure = typ,
    Typedef = typ,

    Special = { fg = fg },
    SpecialChar = { fg = c.code.string, bold = true },
    Tag = { fg = fg },
    Delimiter = { fg = fg },
    Debug = { fg = fg },

    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = c.muted },
    Error = { fg = c.red, bold = true },
    Todo = { fg = c.bg, bg = c.accent, bold = true },
  }
end
