local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if is_plugin_installed('vim-agriculture') then
  nvim_set_keymap('n', '<leader>gg', ':AgRaw<space>', {noremap = true})
  nvim_set_keymap('v', '<leader>gv', ':<Plug>AgRawVisualSelection<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>g*', ':<Plug>AgRawWordUnderCursor<cr>', {noremap = true})
end
