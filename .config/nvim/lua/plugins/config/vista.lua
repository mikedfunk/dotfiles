local is_plugin_installed = require'helpers'.is_plugin_installed
local g, nvim_set_keymap = vim.g, vim.api.nvim_set_keymap

g['vista_close_on_jump'] = 1
g['vista_default_executive'] = 'nvim_lsp'
g['vista#renderer#enable_icon'] = 0
g['vista_fzf_preview'] = {'right:50%'}

if is_plugin_installed('vista.vim') then
  nvim_set_keymap('n', '<leader>bb', ':Vista<cr>', {noremap = true, silent = true})
end
