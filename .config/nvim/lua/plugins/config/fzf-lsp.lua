local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('fzf-lsp.nvim') then
  return
end

require'fzf_lsp'.setup()

nvim_set_keymap('n', '<leader>tt', ':WorkspaceSymbols<space>', {noremap = true})

