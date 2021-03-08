local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('nvim-ale-diagnostic') then
  return
end

require'nvim-ale-diagnostic'

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
