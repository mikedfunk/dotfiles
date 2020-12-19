local helpers = require'helpers'
local create_augroup, minus_equals, plus_equals = helpers.create_augroup, helpers.minus_equals, helpers.plus_equals
local o, nvim_set_keymap = vim.o, vim.api.nvim_set_keymap

o.completeopt = minus_equals(o.completeopt, 'menu')
for k,option in pairs({'menuone', 'noinsert', 'noselect'}) do
  o.completeopt = plus_equals(o.completeopt, option)
end

create_augroup('omnifunc_set', {
  {'FileType', '*', 'if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif'},
})

create_augroup('omnifunc_set_scss', {
  {'FileType', 'scss', 'setlocal omnifunc=csscomplete#CompleteCSS'},
})

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
}
for k,wildignore_pattern in pairs(wildignore_patterns) do
  o.wildignore = plus_equals(o.wildignore, wildignore_pattern)
end

o.wildoptions = plus_equals(o.wildoptions, 'tagfile') -- When using CTRL-D to list matching tags, the kind of tag and the file of the tag is listed.	Only one match is displayed per line.
o.wildoptions = plus_equals(o.wildoptions, 'pum') -- turn the wildmenu into a popup menu

-- tab completion
nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', {noremap = true, expr = true})
nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', {noremap = true, expr = true})
