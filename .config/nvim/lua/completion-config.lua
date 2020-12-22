-- vim; set fdm=marker:
-- this is for general completion settings and fallback non-lsp completion setup
-- renamed from completion to completion-config to avoid naming collision with completion-nvim
local helpers = require'helpers'
local create_augroup, minus_equals, plus_equals = helpers.create_augroup, helpers.minus_equals, helpers.plus_equals
local o, nvim_set_keymap, nvim_set_keymap, nvim_buf_set_keymap = vim.o, vim.api.nvim_set_keymap, vim.api.nvim_set_keymap, vim.api.nvim_buf_set_keymap

-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made (TODO not working for some reason)
-- noselect: Do not select, force user to select one from the menu
o.completeopt = table.concat({'menuone', 'noinsert', 'noselect'}, ',')

create_augroup('omnifunc_set_scss', {
  {'FileType', 'scss', 'setlocal omnifunc=csscomplete#CompleteCSS'},
})

-- create_augroup('omnifunc_set', {
--   {'FileType', '*', 'if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif'},
-- })

local wildignore_patterns = {
  '*.bmp',
  '*.gif',
  '*.ico',
  '*.jpg',
  '*.png',
  '*.ico',
  '*.pdf',
  '*.psd',
  'node_modules/*',
  '.git/*',
  'Session.vim',
  'coverage/*',
}
for k,wildignore_pattern in pairs(wildignore_patterns) do
  o.wildignore = plus_equals(o.wildignore, wildignore_pattern)
end

o.wildoptions = plus_equals(o.wildoptions, 'tagfile') -- When using CTRL-D to list matching tags, the kind of tag and the file of the tag is listed.	Only one match is displayed per line.

-- tab completion
nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {noremap = true, expr = true})
nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {noremap = true, expr = true})

-- show hover details on cursorhold {{{
-- create_augroup('php_hover_def', {
--   {'CursorHold', '*.php', 'silent! lua vim.lsp.buf.hover()'}
-- })
-- }}}
