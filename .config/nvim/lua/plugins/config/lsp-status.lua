local is_plugin_installed = require'helpers'.is_plugin_installed
local g, fn, call, nvim_exec = vim.g, vim.fn, vim.call, vim.api.nvim_exec

if not is_plugin_installed('lsp-status.nvim') then
  return
end

local lsp_status = require'lsp-status'

-- https://github.com/nvim-lua/lsp-status.nvim/issues/7#issuecomment-691056312
-- use LSP SymbolKinds themselves as the kind labels
local kind_labels_mt = {__index = function(_, k) return k end}
local kind_labels = {}
setmetatable(kind_labels, kind_labels_mt)

lsp_status.register_progress()
lsp_status.config {
  kind_labels = kind_labels,
  indicator_errors = "×",
  indicator_warnings = "!",
  indicator_info = "i",
  indicator_hint = "›",
  -- the default is a wide codepoint which breaks absolute and relative
  -- line counts if placed before airline's Z section
  status_symbol = "",
};
