local is_plugin_installed = require'helpers'.is_plugin_installed
local cmd = vim.cmd

if not is_plugin_installed('nvim-lightbulb') then
  return
end

cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
