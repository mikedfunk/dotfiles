local create_augroup = require'helpers'.create_augroup
local lsp, cmd, nvim_set_keymap, sign_define = vim.lsp, vim.cmd, vim.api.nvim_set_keymap, vim.fn.sign_define

-- https://github.com/nvim-lua/diagnostic-nvim/issues/73
lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = ' '
    },
    signs = true, -- This is similar to: let g:diagnostic_show_sign = 1
    update_in_insert = false, -- This is similar to: "let g:diagnostic_insert_delay = 1"
  }
)

nvim_set_keymap('n', '[d', ':lua vim.lsp.diagnostic.goto_prev{wrap = false}<cr>', {noremap = true})
nvim_set_keymap('n', ']d', ':lua vim.lsp.diagnostic.goto_next{wrap = false}<cr>', {noremap = true})

cmd('highlight! link LspDiagnosticsUnderlineError SpellCap')
cmd('highlight! link LspDiagnosticsUnderlineWarning SpellBad')
cmd('highlight! link LspDiagnosticsUnderlineHint SpellRare')
cmd('highlight! link LspDiagnosticsUnderlineInformation SpellRare')
cmd('highlight! link LspDiagnosticsError Comment')
cmd('highlight! link LspDiagnosticsWarning Comment')
cmd('highlight! link LspDiagnosticsHint Comment')
cmd('highlight! link LspDiagnosticsInformation Comment')

sign_define('LspDiagnosticsSignError', {text = '🚨', texthl = 'LspDiagnosticsSignError', linehl = '', numhl = ''})
sign_define('LspDiagnosticsSignWarning', {text = '⚠️', texthl = 'LspDiagnosticsSignWarning', linehl = '', numhl = ''})
sign_define('LspDiagnosticsSignInformation', {text = 'ℹ️', texthl = 'LspDiagnosticsSignInformation', linehl = '', numhl = ''})
sign_define('LspDiagnosticsSignHint', {text = '💡', texthl = 'LspDiagnosticsSignHint', linehl = '', numhl = ''})

-- create_augroup('hover_lsp_diagnostics', {
--   {"CursorHold", "*", "lua vim.lsp.diagnostic.show_line_diagnostics()"},
-- })
