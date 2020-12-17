local o, cmd = vim.o, vim.cmd

o.redrawtime = 10000 -- avoid problem with losting syntax highlighting https://github.com/vim/vim/issues/2790#issuecomment-400547834
o.background = 'dark'

-- show vert lines at the psr-2 suggested column limits
o.colorcolumn = table.concat({
    80,
    120
}, ',')

-- prettier hidden chars. turn on with :set list or yol (different symbols)
o.listchars = table.concat({
    "nbsp:␣",
    "tab:▸•",
    "eol:↲",
    "trail:•",
    "extends:»",
    "precedes:«",
    "trail:•",
}, ',')

cmd('highlight! Comment cterm=italic, gui=italic') -- italic comments https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic

o.termguicolors = true

-- TIP: z= will show spell completion options. zg will add the word to the
-- spelling library. zw will mark a word as incorrect spelling. set spell or
-- yos will toggle spellcheck. ]s [s will go to next/prev spell error.
o.spelllang = 'en_us'
