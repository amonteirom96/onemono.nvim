if vim.g.loaded_onemono then
  return
end
vim.g.loaded_onemono = true

local cmd = vim.api.nvim_create_user_command

cmd("OnemonoCompile", function()
  require("onemono").compile()
end, { desc = "onemono: rebuild the compiled highlight cache" })

cmd("OnemonoClearCache", function()
  require("onemono").clear_cache()
end, { desc = "onemono: delete the compiled highlight cache" })

cmd("OnemonoExtras", function(args)
  local out = require("onemono").extras(args.args ~= "" and args.args or nil)
  vim.notify("onemono: extras written to " .. out)
end, { nargs = "?", complete = "dir", desc = "onemono: generate ghostty/kitty/lazygit themes" })
