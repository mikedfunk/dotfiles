local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('nvim-lspfuzzy') then
  return
end

require'lspfuzzy'.setup{
  methods = {
    -- 'callHierarchy/incomingCalls',
    -- 'callHierarchy/outgoingCalls',
    -- 'textDocument/codeAction',
    -- 'textDocument/declaration',
    -- 'textDocument/definition',
    -- 'textDocument/documentSymbol',
    -- 'textDocument/implementation',
    'textDocument/references',
    -- 'textDocument/typeDefinition',
    'workspace/symbol',
  }
}

nvim_set_keymap('n', '<leader>tt', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {noremap = true})
