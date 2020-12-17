local minus_equals = require'helpers'.minus_equals
local cmd, o, nvim_set_keymap = vim.cmd, vim.o, vim.api.nvim_set_keymap

-- cmd('scriptencoding utf-8')
cmd('filetype plugin indent on')
cmd('syntax enable')
o.autoindent = true
o.backspace = table.concat({
  'indent',
  'eol',
  'start',
}, ',')

-- disable some completion sources for faster completion:
-- i: included files: prevent a condition where vim lags due to searching include files.
-- t: tag completion
o.completeopt = minus_equals(o.completeopt, 'preview')
o.nrformats = minus_equals(o.nrformats, 'octal')
o.incsearch = true
-- Use <C-L> to clear the highlighting of :set hlsearch.
nvim_set_keymap('n', '<C-L>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>", {noremap = true})

o.laststatus = 2
o.ruler = true
o.wildmenu = true
o.scrolloff = 3
o.sidescrolloff = 5

o.display = "lastline" -- display is empty by default

-- o.relativenumber = true -- turn on relative line numbers
cmd('set relativenumber') -- turn on relative line numbers
o.tags = './tags' -- avoid searching for other tags files
o.autoread = true
o.history = 1000
o.tabpagemax = 50

-- remove "options"
o.sessionoptions = minus_equals(o.sessionoptions, 'options')
