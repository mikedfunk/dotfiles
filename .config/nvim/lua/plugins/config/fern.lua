local helpers = require'helpers'
local is_plugin_installed = helpers.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('fern.vim') then
  return
end

nvim_set_keymap('n', '-', ':Fern . -reveal=%<cr>', {noremap = true})
