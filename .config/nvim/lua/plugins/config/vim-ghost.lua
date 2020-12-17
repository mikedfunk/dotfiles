local is_plugin_installed = require'helpers'.is_plugin_installed
local g, nvim_set_keymap = vim.g, vim.api.nvim_set_keymap

g['ghost_darwin_app'] = 'iTerm2'

if is_plugin_installed('vim-ghost') then
  nvim_set_keymap('n', '<leader>g+', ':GhostStart<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>g=', ':GhostStop<cr>', {noremap = true})
end
