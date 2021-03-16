local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('lspsaga.nvim') then
  return
end

-- default value
-- use_saga_diagnostic_sign = true
-- error_sign = '',
-- warn_sign = '',
-- hint_sign = '',
-- infor_sign = '',
-- dianostic_header_icon = '   ',
-- code_action_icon = ' ',
-- code_action_prompt = {
--   enable = true,
--   sign = true,
--   sign_priority = 20,
--   virtual_text = true,
-- },
-- code_action_keys = { quit = 'q',exec = '<CR>' }
-- finder_definition_icon = '  ',
-- finder_reference_icon = '  ',
-- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
-- finder_action_keys = {
--   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
-- },
-- code_action_keys = {
--   quit = 'q',exec = '<CR>'
-- },
-- rename_action_keys = {
--   quit = '<C-c>',exec = '<CR>'  -- quit can be a table
-- },
-- definition_preview_icon = '  '
-- 1: thin border | 2: rounded border | 3: thick border | 4: ascii border
-- border_style = 1
-- rename_prompt_prefix = '➤',
-- if you don't use nvim-lspconfig you must pass your server name and
-- the related filetypes into this table
-- like server_filetype_map = {metals = {'sbt', 'scala'}}
-- server_filetype_map = {}

require'lspsaga'.init_lsp_saga{
  code_action_prompt = {
    sign = false,
  }
}
nvim_set_keymap('n', 'L', "<cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>", {noremap = true, silent = true}) -- may want to remap this to L so K can still be used for devdocs... still deciding
nvim_set_keymap('n', '<c-f>', "<cmd>lua require'lspsaga.action'.smart_scroll_with_saga(1)<CR>", {noremap = true, silent = true}) -- scroll down hover doc or scroll in definition preview
nvim_set_keymap('n', '<c-b>', "<cmd>lua require'lspsaga.action'.smart_scroll_with_saga(-1)<CR>", {noremap = true, silent = true}) -- scroll up hover doc

nvim_set_keymap('i', '<c-k>', "<cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>", {noremap = true, silent = true})
nvim_set_keymap('n', '<c-k>', "<cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>", {noremap = true, silent = true})

nvim_set_keymap('n', '<leader>rr', "<cmd>lua require'lspsaga.rename'.rename()<CR>", {noremap = true, silent = true})

nvim_set_keymap('n', '<c-w>}', "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", {noremap = true, silent = true})

nvim_set_keymap('n', 'gr', "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", {noremap = true, silent = true})
nvim_set_keymap('n', '<leader>cc', "<cmd>lua require'lspsaga.codeaction'.code_action()<CR>", {noremap = true, silent = true})
nvim_set_keymap('v', '<leader>cc', "<cmd>lua require'lspsaga.codeaction'.range_code_action()<CR>", {noremap = true, silent = true})
