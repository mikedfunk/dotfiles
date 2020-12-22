local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('telescope.nvim') then
  return
end

nvim_set_keymap('n', '<leader>ff', ":lua require'telescope.builtin'.find_files()<cr>", {noremap = true})
nvim_set_keymap('n', '<leader>ag', ":lua require'telescope.builtin'.live_grep()<cr>", {noremap = true})
nvim_set_keymap('n', '<leader>hh', ":lua require'telescope.builtin'.help_tags()<cr>", {noremap = true})
-- nvim_set_keymap('n', '<leader>tt', ":lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", {noremap = true}) -- "No results from workspace/symbol" every time
