local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('lspkind-nvim') then
  return
end

require('lspkind').init()
