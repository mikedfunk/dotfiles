local helpers = require'helpers'
local create_augroup, minus_equals, plus_equals = helpers.create_augroup, helpers.minus_equals, helpers.plus_equals
local g, o, cmd, nvim_set_keymap, executable, filereadable, getenv = vim.g, vim.o, vim.cmd, vim.api.nvim_set_keymap, vim.fn.executable, vim.fn.filereadable, o.getenv

-- cmd 'runtime macros/matchit.vim'
g['mapleader'] = ','
-- since , replaces leader, use \ to go back in a [f]ind
nvim_set_keymap('n', '\\', ',', {noremap = true})

-- TODO these aren't working. Confirmed broken in latest nightly. See end of main init.vim.
o.exrc = true -- enables reading .exrc or .nvimrc from current directory
o.secure = true -- Always append set secure when exrc option is enabled!

o.pumblend = 20 -- enable pseudo-transparency for popup menu
o.fileformat = 'unix' -- Any non-unix line endings are converted to unix
o.joinspaces = false -- Prevents inserting two spaces after punctuation on a join (J)
o.splitright = true -- Puts new vsplit windows to the right of the current
o.splitbelow = true -- Puts new split windows to the bottom of the current
o.ignorecase = true -- Case insensitive search. Needed for smartcase to work.
o.infercase = true -- smarter, case-aware completion in insert mode.
o.lazyredraw = true -- to speed up rendering and avoid scrolling problems
o.smartcase = true -- Case sensitive when uc present
o.ttimeoutlen = 0 -- Timeout for escape sequences https://github.com/wincent/terminus/issues/9
-- o.number = true -- turn on line numbers
cmd('set number') -- turn on line numbers
o.iskeyword = minus_equals(o.iskeyword, '.') -- '.' is an end of word designator
o.iskeyword = minus_equals(o.iskeyword, '-') -- '-' is an end of word designator
o.path = "**" -- only search in git root
o.hlsearch = false -- turn off search result highlighting
-- o.modeline = true -- enable modeline (comments in a file that apply vim settings)
cmd('set modeline')
o.modelines = 5 -- set number of lines that are checked for commands
o.showmode = false -- turn off showing mode (normal, visual, etc) on the last line
o.ttyfast = true -- speeds up terminal vim rendering
o.undofile = true -- persistent undo
o.swapfile = false -- turn off swapfiles - they are annoying and only useful if neovim crashes before I saved
o.shortmess = o.shortmess .. 'I' -- hide the launch screen
o.shortmess = o.shortmess .. 'c' -- hide 'back at original', 'match (x of x)', etc.
o.startofline = false -- Keep the cursor on the same column
o.t_kB = "[Z" -- Shift-tab on GNU screen

-- escape codes for italic fonts
o.t_ZH = "[3m"
o.t_ZR = "[23m"

-- use system clipboard. If this isn't here you have to \"* before every
-- yank/delete/paste command. Really annoying. Leader commands are tricky too
-- if you want to make them work with motions and visual selections.
o.clipboard = "unnamed"

o.concealcursor = "" -- do not conceal anything when cursor is over a line
o.inccommand = 'split' -- preview susbstitute in neovim https://dev.to/petermbenjamin/comment/7ng0
o.mouse = 'a' -- Automatically enable mouse usage
-- TODO not found: o.mousehide = true
-- TODO if &term =~# '^screen'
-- TODO not found: o.ttymouse = 'sgr' -- enable split dragging

create_augroup('ignorecase_augroup', {
  {"InsertEnter", "*", "set noignorecase"},
  {"InsertLeave", "*", "set ignorecase"},
})

if executable('ag') == 1 then
  o.grepprg = 'ag --vimgrep'
  o.grepformat = '%f:%l:%c%m'
elseif executable('git') == 1 then
  o.grepprg = 'git'
  o.grepformat = '%f:%l:%m,%m %f match%ts,%f'
end

-- auto open quickfix window on search if results found
create_augroup('quickfix_open', {
  {"QuickFixCmdPost", "[^l]*", "cwindow"},
  {"QuickFixCmdPost", "l*", "lwindow"},
})

-- if the last window is a quickfix, close it
create_augroup('quickfix_autoclose', {
  {"WinEnter", "*", "if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix'|q|endif"},
})

-- Automatically equalize splits when Vim is resized https://vi.stackexchange.com/a/206/11130
create_augroup('resize_equalize', {
  {"VimResized", "*", "wincmd ="},
})

-- this is because some of my notes start with 'vim:'
create_augroup('disable_modeline_for_markdown', {
  {"FileType", "markdown", "setlocal nomodeline"},
})

nvim_set_keymap('n', 'Q', '<nop>', {noremap = true}) -- disable Ex mode

-- set filetypes for unusual files
create_augroup('unusual_filetypes', {
  {"BufRead,BufNewFile", "*.phtml", "setlocal filetype=phtml.html"},
  {"BufRead,BufNewFile", "*.eyaml", "setlocal filetype=yaml"},
  {"BufRead,BufNewFile", ".babelrc", "setlocal filetype=json"},
  {"BufRead,BufNewFile", ".php_cs", "setlocal filetype=php"},
  {"BufRead,BufNewFile", "*.php.sample", "setlocal filetype=php"},
  {"BufRead,BufNewFile", "*.php.dist", "setlocal filetype=php"},
  {"BufRead,BufNewFile", "*.php.dist", "setlocal filetype=php"},
  {"BufRead,BufNewFile", "{haproxy.cfg,ssl-haproxy.cfg}", "setlocal filetype=haproxy"},
  {"BufRead,BufNewFile", "{site.conf,default.conf}", "setlocal filetype=nginx"},
  {"BufRead,BufNewFile", "{.curlrc,.gitignore,.gitattributes,.hgignore,.jshintignore}", "setlocal filetype=conf"},
  {"BufRead,BufNewFile", ".editorconfig", "setlocal filetype=dosini"},
  {"BufRead,BufNewFile", ".Brewfile", "setlocal filetype=sh"},
  {"BufRead,BufNewFile", ".sshrc", "setlocal filetype=sh"},
  {"BufRead,BufNewFile", ".tigrc", "setlocal filetype=gitconfig"},
  {"BufRead,BufNewFile", "{.env,.env.*}", "setlocal filetype=dosini"},
  {"BufRead,BufNewFile", "*.cnf", "setlocal filetype=dosini"},
  {"BufRead,BufNewFile", ".spacemacs", "setlocal filetype=lisp"},
  {"BufRead,BufNewFile", ".envrc", "setlocal filetype=sh"},
})

-- open quickfix in vsplit, tab, split
create_augroup('quickfix_mappings', {
  {'FileType', 'qf', 'nmap <buffer> s <C-w><Enter>'},
  {'FileType', 'qf', 'nmap <buffer> v <C-w><Enter><C-w>L'},
  {'FileType', 'qf', 'nmap <buffer> t <C-W><Enter><C-W>T'},
  -- move the quickfix to the bottom, stretched from left to right whenever
  -- it opens. Without this, if you have 2 vertical splits and you grep
  -- something, it will show up at the bottom of the current split only. This
  -- is frustrating when you have 3 or 4 splits as it makes the results
  -- difficult to read and navigate to.
  -- TODO this is probably causing my quickfix bug
  -- {'FileType', 'qf', 'wincmd J'},
})

-- web-based documentation with shift-K
-- https://www.reddit.com/r/vim/comments/3oo1e0/has_anyone_found_a_way_to_make_k_useful/
-- NOTE: keywordprg is not invoked silently, so you will get 'press enter to continue'
create_augroup('devdocs_keywordprg', {
  {'FileType', 'php', 'set keywordprg="devdocs php"'},
  {'FileType', 'javascript*', 'set keywordprg="devdocs javascript"'},
  {'FileType', 'html', 'set keywordprg="devdocs html"'},
  {'FileType', 'ruby', 'set keywordprg="devdocs ruby"'},
  {'FileType', 'css*', 'set keywordprg="devdocs css"'},
  {'FileType', 'zsh', 'set keywordprg="devdocs bash"'},
  {'FileType', 'bash', 'set keywordprg="devdocs bash"'},
  {'FileType', 'sh', 'set keywordprg="devdocs bash"'},
})

-- line text object e.g. `vil` `yil`
nvim_set_keymap('x', 'il', "0o$h", {noremap = true})
nvim_set_keymap('o', 'il', ":normal vil<CR>", {noremap = true})

-- preview window - close it on leave insert
create_augroup('close_preview_on_insert', {
  {'InsertLeave,CompleteDone', '*', 'if pumvisible() == 0 | pclose | endif'},
})

-- https://blog.kdheepak.com/three-built-in-neovim-features.html#highlight-yanked-text
create_augroup('lua_highlight', {
  {'TextYankPost', '*', "silent! lua require'vim.highlight'.on_yank()"},
})

o.diffopt = plus_equals(o.diffopt, 'hiddenoff') -- Do not use diff mode for a buffer when it becomes hidden

if filereadable('/usr/share/dict/words') == 1 then
  o.dictionary = plus_equals(o.dictionary, '/usr/share/dict/words') -- Make <c-o><c-k> complete English words
end

-- remove the $ sign from what consitutes a 'word' in vim
create_augroup('dollar_sign_php', {
  {'FileType', 'php', "setlocal iskeyword -=$"},
})

-- You can get Lua syntax highlighting inside .vim files by putting let
-- g:vimsyn_embed = 'l' in your configuration file. See :help g:vimsyn_embed
-- for more on this option.
g['vimsyn_embed'] = 'l'

-- folding for some filetypes
create_augroup('folding_for_some_filetypes', {
  {'FileType', 'json', 'setlocal foldmethod=indent'},
  {'FileType', 'yaml', 'setlocal foldmethod=indent'},
})

-- built-in highlight on yank
create_augroup('highlight_on_yank', {
  {'TextYankPost', '*', 'silent! lua vim.highlight.on_yank()'},
})

o.backupdir = getenv('HOME') .. '/.config/nvim/backup'
o.viewdir = getenv('HOME') .. '/.config/nvim/views'
o.directory = getenv('HOME') .. '/.config/nvim/swap'
o.undodir = getenv('HOME') .. '/.config/nvim/undo'
