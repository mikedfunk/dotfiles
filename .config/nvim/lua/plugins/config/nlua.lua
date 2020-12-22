local is_plugin_installed = require'helpers'.is_plugin_installed

if not is_plugin_installed('nlua') or not is_plugin_installed('nvim-lspconfig') then
  return
end

local nlua_lsp = require'nlua.lsp.nvim'
local lspconfig = require'lspconfig'

-- To get builtin LSP running, do something like:
-- NOTE: This replaces the calls where you would have before done `require('nvim_lsp').sumneko_lua.setup()`
nlua_lsp.setup(lspconfig, {
  -- on_attach = custom_nvim_lspconfig_attach,

  -- Include globals you want to tell the LSP are real :)
  globals = {
    'vim',
    'use',
  }
})
