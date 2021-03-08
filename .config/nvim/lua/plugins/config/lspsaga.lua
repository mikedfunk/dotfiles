local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('lspsaga.nvim') then
  return
end

require'lspsaga'.init_lsp_saga{}

nvim_set_keymap('n', 'gr', "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", {noremap = true, silent = true})
nvim_set_keymap('n', '<leader>cc', "<cmd>lua require'lspsaga.codeaction'.code_action()<CR>", {noremap = true, silent = true})
nvim_set_keymap('v', '<leader>cc', "<cmd>lua require'lspsaga.codeaction'.range_code_action()<CR>", {noremap = true, silent = true})
