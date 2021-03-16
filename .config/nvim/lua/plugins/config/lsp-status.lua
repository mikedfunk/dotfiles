local helpers = require'helpers'
local create_augroup, is_plugin_installed = helpers.create_augroup, helpers.is_plugin_installed
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

if not is_plugin_installed('vim-airline') then
  return
end

-- vim-airline integration

g['airline#extensions#nvimlsp#enabled'] = 0

-- intentionally global
function lsp_status_airline_init()
  -- TODO convert to lua
  nvim_exec([[
  function! LspStatus() abort
    let status = luaeval('require"lsp-status".status()')
    return trim(status)
  endfunction
  ]], true)

  call('airline#parts#define_function', 'lsp_status', 'LspStatus')
  call('airline#parts#define_condition', 'lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')

  g['airline_section_x'] = call('airline#section#create_right', {'lsp_status', g['airline_section_x']})
end

create_augroup('lsp_status_airline', {
  {'User', 'AirlineAfterInit', ':lua lsp_status_airline_init()'},
})
