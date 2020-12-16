-- vim: set fdm=marker:

-- lua reference {{{
-- get a path beneath the standard path: `fn.stdpath('cache')`
-- concat strings: `string1 .. string2`
-- string.{len, lower, match, pack, packsize, rep, reverse, sub, unpack, upper}
-- table.{concat, insert, move, pack, remove, sort, unpack}
-- }}}

-- helper functions {{{
-- api: {Object} = nvim api functions
-- cmd: {Function} = call a vim command
-- fn: {Object} = call a vim helper function
-- o: {Object} = set a vim option
-- g: {Function} = set a vim global var
-- wo: {Object} = set an option only for this window
-- bo: {Object} = set an option only for this buffer
local api, cmd, fn, g, v = vim.api, vim.cmd, vim.fn, vim.g, vim.v
local o, wo, bo = vim.o, vim.wo, vim.bo
local nvim_set_keymap = api.nvim_set_keymap
local executable, has, filereadable, getenv, isdirectory, mkdir = fn.executable, fn.has, fn.filereadable, fn.getenv, fn.isdirectory, fn.mkdir

local helpers = require'helpers'
-- }}}

-- plugins {{{
require'plugins'
-- }}}

-- initialize directories {{{
local function initialize_directories()
  local dir_list = {
    backup = 'backupdir',
    views = 'viewdir',
    swap = 'directory',
    undo = 'undodir',
  }

  local common_dir = getenv('HOME') .. '/.config/nvim/'

  for dir_name, setting_name in pairs(dir_list) do
    local dir = common_dir .. dir_name .. '/'

    if isdirectory(dir) == 0 then
      mkdir(dir)
    end

    if isdirectory(dir) == 0 then
      cmd('echo "Warning: Unable to create backup directory: ' .. dir .. '"')
      cmd('echo "Try: mkdir -p ' .. dir .. '"')
    else
      cmd('set ' .. setting_name .. '=' .. dir)
    end
  end
end
initialize_directories()
-- }}}

-- Sensible.vim {{{
local function sensible_vim()
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
  o.completeopt = helpers.minus_equals(o.completeopt, 'preview')
  o.nrformats = helpers.minus_equals(o.nrformats, 'octal')
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
  o.sessionoptions = helpers.minus_equals(o.sessionoptions, 'options')
end
sensible_vim()
-- }}}

-- General {{{
local function general_setup()
  -- cmd 'runtime macros/matchit.vim'
  g['mapleader'] = ','
  -- since , replaces leader, use \ to go back in a [f]ind
  nvim_set_keymap('n', '\\', ',', {noremap = true})

  -- TODO these aren't working. See end of this file.
  o.exrc = true -- enables reading .exrc or .vimrc from current directory
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
  o.iskeyword = helpers.minus_equals(o.iskeyword, '.') -- '.' is an end of word designator
  o.iskeyword = helpers.minus_equals(o.iskeyword, '-') -- '-' is an end of word designator
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

  helpers.create_augroup('ignorecase_augroup', {
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
  helpers.create_augroup('quickfix_open', {
    {"QuickFixCmdPost", "[^l]*", "cwindow"},
    {"QuickFixCmdPost", "l*", "lwindow"},
  })

  -- if the last window is a quickfix, close it
  helpers.create_augroup('quickfix_autoclose', {
    {"WinEnter", "*", "if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix'|q|endif"},
  })

  -- Automatically equalize splits when Vim is resized https://vi.stackexchange.com/a/206/11130
  helpers.create_augroup('resize_equalize', {
    {"VimResized", "*", "wincmd ="},
  })

  -- this is because some of my notes start with 'vim:'
  helpers.create_augroup('disable_modeline_for_markdown', {
    {"FileType", "markdown", "setlocal nomodeline"},
  })

  nvim_set_keymap('n', 'Q', '<nop>', {noremap = true}) -- disable Ex mode

  -- set filetypes for unusual files
  helpers.create_augroup('unusual_filetypes', {
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
  helpers.create_augroup('quickfix_mappings', {
    {'FileType', 'qf', 'nmap <buffer> s <C-w><Enter>'},
    {'FileType', 'qf', 'nmap <buffer> v <C-w><Enter><C-w>L'},
    {'FileType', 'qf', 'nmap <buffer> t <C-W><Enter><C-W>T'},
    -- move the quickfix to the bottom, stretched from left to right whenever
    -- it opens. Without this, if you have 2 vertical splits and you grep
    -- something, it will show up at the bottom of the current split only. This
    -- is frustrating when you have 3 or 4 splits as it makes the results
    -- difficult to read and navigate to.
    -- TODO this is probably causing my quickfix bug
    {'FileType', 'qf', 'wincmd J'},
  })

  -- web-based documentation with shift-K
  -- https://www.reddit.com/r/vim/comments/3oo1e0/has_anyone_found_a_way_to_make_k_useful/
  -- NOTE: keywordprg is not invoked silently, so you will get 'press enter to continue'
  helpers.create_augroup('devdocs_keywordprg', {
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
  helpers.create_augroup('close_preview_on_insert', {
    {'InsertLeave,CompleteDone', '*', 'if pumvisible() == 0 | pclose | endif'},
  })

  -- https://blog.kdheepak.com/three-built-in-neovim-features.html#highlight-yanked-text
  helpers.create_augroup('lua_highlight', {
    {'TextYankPost', '*', "silent! lua require'vim.highlight'.on_yank()"},
  })

  o.diffopt = helpers.plus_equals(o.diffopt, 'hiddenoff') -- Do not use diff mode for a buffer when it becomes hidden

  if filereadable('/usr/share/dict/words') == 1 then
    o.dictionary = helpers.plus_equals(o.dictionary, '/usr/share/dict/words') -- Make <c-o><c-k> complete English words
  end

  -- remove the $ sign from what consitutes a 'word' in vim
  helpers.create_augroup('dollar_sign_php', {
    {'FileType', 'php', "setlocal iskeyword -=$"},
  })

  -- You can get Lua syntax highlighting inside .vim files by putting let
  -- g:vimsyn_embed = 'l' in your configuration file. See :help g:vimsyn_embed
  -- for more on this option.
  g['vimsyn_embed'] = 'l'

  -- folding for some filetypes
  helpers.create_augroup('folding_for_some_filetypes', {
    {'FileType', 'json', 'setlocal foldmethod=indent'},
    {'FileType', 'yaml', 'setlocal foldmethod=indent'},
  })

  -- built-in highlight on yank
  helpers.create_augroup('highlight_on_yank', {
    {'TextYankPost', '*', 'silent! lua vim.highlight.on_yank()'},
  })
end
general_setup()
-- }}}

-- php settings {{{
local function php_settings()
  g['PHP_removeCRwhenUnix'] = 1
  -- means that PHP tags will match the indent of the HTML around them in files that a mix of PHP and HTML
  g['PHP_outdentphpescape'] = 0
  g['php_htmlInStrings'] = 1 -- neat! :h php.vim
  g['php_baselib'] = 1 -- highlight php builtin functions
  -- g['php_folding'] = 1 -- fold methods, control structures, etc.
  g['php_noShortTags'] = 1
  g['php_parent_error_close'] = 1 -- highlight missing closing ] or )
  g['php_parent_error_open'] = 1 -- highlight missing opening [ or (
  g['php_syncmethod'] = 10 -- :help :syn-sync https://stackoverflow.com/a/30732393/557215

  -- doxygen support is _extremely_ buggy for php in neovim. Works fine in vim.
  -- e.g. if a class is taller than the current viewport and you go to the last
  -- curly brace in a class, it breaks syntax until you page back up to whatever
  -- line breaks it. Then if you go back to the last curly brace it breaks again.
  -- Not worth it. Apparently it has something to do with php extending html as
  -- the broken highlight group is `htmlError`. It could be related to this
  -- https://github.com/sheerun/vim-polyglot/blob/28388008327aacfc48db3c31f415564d93cd983f/syntax/php.vim#L73
  -- I think it has to do with nested braces in parens.
  -- :h doxygen
  -- g['load_doxygen_syntax'] = 1 -- pretty docblocks in php, c, etc.
  -- g['doxygen_enhanced_color'] = 1 -- prettier docblocks

  helpers.create_augroup('php_helpers', {
      -- sort use statements alphabetically
    {"FileType", "php", "nnoremap <leader>su :call PhpSortUse()<cr>"},
    -- expand interface methods
    -- TODO fix invalid escape sequence
    -- {"FileType", "php", 'nnoremap <leader>ei :%s/\v(\w+\sfunction\s\w+\(.*\))(\: \w+)?;/\1\2\r    {\r        \/\/\r    }/g<cr>'},
    -- methods to interface signatures,
    {"FileType", "php", "nnoremap <leader>em :%g/    public function/normal! jd%kA;<cr>"},
  })

  -- TODO convert to lua
  -- " single line to multiline docblock
  -- function PhpSingleToMultiDocblock() abort
  --     :.,.s/\/\*\* \(.*\) \*\//\/\*\*\r     * \1\r     *\//g
  -- endfunction
  -- augroup phpsingletomultilinedocblockgroup
  --     autocmd!
  --     autocmd FileType php nnoremap <leader>cm :call PhpSingleToMultiDocblock()<cr>
  -- augroup END

  -- array() to [] TODO

  -- TODO conver to lua
  -- " prefix php namespaces
  -- function! PhpPrefixNamespaces() abort
  --     silent! %s/@\([a-z]\+\) \([A-Z]\)/@\1 \\\2/g
  --     silent! %s/@author \\/@author /g
  --     nohlsearch
  -- endfunction
  -- command! PhpPrefixNamespaces :call PhpPrefixNamespaces()

  helpers.create_augroup('php_break_chain_map', {
    {'FileType', 'php', 'nnoremap <leader>. ^f-i<enter><esc>'},
  })

  cmd('highlight! link phpDocTags phpDefine')
  cmd('highlight! link phpDocParam phpType')
  cmd('highlight! link phpDocParam phpRegion')
  cmd('highlight! link phpDocIdentifier phpIdentifier')
  cmd('highlight! link phpUseNamespaceSeparator Comment') -- Colorize namespace separator in use, extends and implements
  cmd('highlight! link phpClassNamespaceSeparator Comment')
end
php_settings()
-- }}}

-- completion {{{
local function completion_setup()
  o.completeopt = helpers.minus_equals(o.completeopt, 'menu')
  for k,option in pairs({'menu', 'menuone', 'noinsert', 'noselect'}) do
    o.completeopt = helpers.plus_equals(o.completeopt, option)
  end

  helpers.create_augroup('omnifunc_set', {
    {'FileType', '*', 'if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif'},
  })

  helpers.create_augroup('omnifunc_set_scss', {
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
    o.wildignore = helpers.plus_equals(o.wildignore, wildignore_pattern)
  end

  o.wildoptions = helpers.plus_equals(o.wildoptions, 'tagfile') -- When using CTRL-D to list matching tags, the kind of tag and the file of the tag is listed.	Only one match is displayed per line.

  -- tab completion
  nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', {noremap = true, expr = true})
  nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', {noremap = true, expr = true})
end
completion_setup()
-- }}}

-- abbreviations {{{
local function abbreviations_setup()
  -- I am slow on the shift key
  cmd('abbrev willREturn willReturn')
  cmd('abbrev shouldREturn shouldReturn')

  cmd('abbrev willTHrow willThrow')

  cmd('abbrev sectino section')

  cmd('abbrev colleciton collection')
  cmd('abbrev Colleciton Collection')

  cmd('abbrev conneciton connection')
  cmd('abbrev Conneciton Connection')

  cmd('abbrev connecitno connection')
  cmd('abbrev Connecitno Connection')

  cmd('abbrev leagcy legacy')
  cmd('abbrev Leagcy Legacy')

  cmd("cabbr <expr> %% expand('%:p:h')") -- in ex mode %% is current dir
end
abbreviations_setup()
-- }}}

-- mappings {{{
local function mappings_setup()
  nvim_set_keymap('n', '<leader>so', ":lua require'plugins'<cr>", {noremap = true})
  -- from practical vim recommendation
  nvim_set_keymap('c', '<c-p>', '<Up>', {noremap = true})
  nvim_set_keymap('c', '<c-n>', '<Down>', {noremap = true})

  -- put cursor at end of text on y and p
  nvim_set_keymap('v', 'y', 'y`]', {noremap = true, silent = true})
  nvim_set_keymap('v', 'p', 'p`]', {noremap = true, silent = true})
  nvim_set_keymap('n', 'p', 'p`]', {noremap = true, silent = true})

  -- Visual shifting (does not exit Visual mode)
  nvim_set_keymap('v', '<', '<gv', {noremap = true})
  nvim_set_keymap('v', '>', '>gv', {noremap = true})

  -- Wrapped lines goes down/up to next row, rather than next line in file.
  nvim_set_keymap('n', 'j', "v:count ? 'j' : 'gj'", {noremap = true, expr = true})
  nvim_set_keymap('n', 'k', "v:count ? 'k' : 'gk'", {noremap = true, expr = true})

  -- Easier horizontal scrolling
  nvim_set_keymap('n', 'zl', 'zL', {noremap = true})
  nvim_set_keymap('n', 'zh', 'zH', {noremap = true})

  -- my version of fast tabs. Doesn't work in netrw tabs.
  nvim_set_keymap('n', 'gh', 'gT', {noremap = true})
  nvim_set_keymap('n', 'gl', 'gt', {noremap = true})
  nvim_set_keymap('n', "<c-w>t", ':tabe<cr>', {noremap = true})

  -- for all tag jumps, show the menu when there are more than one result! if
  -- only one result, jump away. :h tjump. I don't see why I would want to do it
  -- any other way!! The default sucks - it sometimes takes me to the wrong match
  -- because it's the first match.
  nvim_set_keymap('n', '<c-]>', ':exec("tjump ".expand("<cword>"))<cr>', {noremap = true})

  -- TODO convert to lua
  -- open tag in tab
  -- this should really just be <c-w>g<c-]> then <c-w>T but I couldn't get that
  -- to work
  -- function! OpenTagInNewTab () abort
  --     :normal! mz
  --     :tabe %
  --     :normal! `z
  --     :exec("tjump ".expand('<cword>'))
  -- endfunction
  -- nnoremap <silent><leader><c-]> :call OpenTagInNewTab()<cr>

  nvim_set_keymap('n', '<c-w><c-]>', ':vsp<CR>:exec("tjump ".expand("<cword>"))<CR>', {noremap = true}) -- open tag in vertical split
  nvim_set_keymap('n', '<c-w>}', ':exec("ptjump ".expand("<cword>"))<CR>', {noremap = true}) -- open tag in preview window (<c-w><c-z> to close)

  -- stupid f1 help
  nvim_set_keymap('n', '<f1>', '<nop>', {noremap = true})
  nvim_set_keymap('i', '<f1>', '<nop>', {noremap = true})

  -- TODO convert to lua
  -- " switch to the last active tab
  -- let g:lasttab = 1
  -- nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
  -- augroup tableavegroup
  --     autocmd!
  --     autocmd TabLeave * let g:lasttab = tabpagenr()
  -- augroup END

  nvim_set_keymap('n', '<leader>fa', ':delmarks z<cr>hh :echo "formatted file"<cr>', {noremap = true}) -- format all

  nvim_set_keymap('n', '<leader>wg', ':grep! <cword> .<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>Wg', ':grep! "\b<cword>\b" .<cr>', {noremap = true})

  -- fuzzy open
  nvim_set_keymap('n', '<leader>fe', ':e **/*', {noremap = true})
  nvim_set_keymap('n', '<leader>ft', ':tabe **/*', {noremap = true})
  nvim_set_keymap('n', '<leader>ft', ':vsp **/*', {noremap = true})
  nvim_set_keymap('n', '<leader>fs', ':sp **/*', {noremap = true})

  nvim_set_keymap('n', '<leader>je', ':tjump<space>', {noremap = true})
  nvim_set_keymap('n', '<leader>jv', ':vsp<CR>:tag<space>', {noremap = true})
  nvim_set_keymap('n', '<leader>jt', ':tabe<CR>:tag<space>', {noremap = true})

  -- diffs
  nvim_set_keymap('n', '<leader>dr', ':diffget REMOTE<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>dl', ':diffget LOCAL<cr>', {noremap = true})

  -- TODO convert to lua
  -- " open current file in browser (useful for markdown preview)
  -- function! PreviewInBrowser() abort
  --     " silent !open -a "Google Chrome" %:p
  --     silent !open -a "Firefox" %:p
  --     redraw!
  -- endfunction
  -- command! PreviewInBrowser :call PreviewInBrowser()


  -- TODO conver to lua - problem with quotes
  -- http://vim.wikia.com/wiki/Highlight_current_line
  -- nnoremap <silent> <Leader>hl :exe "let m = matchadd('Search','\\%" . line('.') . "l')"<CR>
  -- nnoremap <silent> <Leader>hw :exe "let m=matchadd('Search','\\<\\w*\\%" . line(".") . "l\\%" . col(".") . "c\\w*\\>')"<CR>
  -- nnoremap <silent> <Leader>hc :call clearmatches()<CR>

  nvim_set_keymap('n', '<leader>zz', ':lua vim.lsp.buf.code_action()<cr>', {noremap = true})
end
mappings_setup()
-- }}}

-- netrw {{{
local function configure_netrw()
  g['netrw_liststyle'] = 3 -- tree style
  nvim_set_keymap('c', '%%', "<C-R>=fnameescape(expand('%:h')).'/'<cr>", {noremap = true}) -- http://vimcasts.org/episodes/the-edit-command/
  nvim_set_keymap('n', '<c-e>', ":silent! Lex <C-R>=fnameescape(expand('%:h')).'/'<cr><cr>", {noremap = true, silent = true}) -- open netrw to current file

  -- TIP: to cd to the directory of the current file:
  -- `:cd %%` (or on generic vim: `:cd %:h`)
  -- Then to cd back to git root:
  -- `:Gcd` (or `:cd -`)
  -- Useful for <c-x><c-f> for javascript imports
  -- Also you can <c-o> when in insert mode to temporarily run commands and jump
  -- back to insert mode when done

  g['netrw_localrmdir'] = 'rm -r' -- Allow netrw to remove non-empty local directories
  g['netwr_winsize'] = -40
  g['netwr_banner'] = 0

  -- https://github.com/vim/vim/issues/2329#issuecomment-350294641
  helpers.create_augroup('netrw_fix', {
    {'BufRead,BufWritePost', 'scp://*', 'set backtrace=acwrite'},
  })

  -- https://vi.stackexchange.com/a/13012
  -- Per default, netrw leaves unmodified buffers open. This autocommand
  -- deletes netrw's buffer once it's hidden (using ':q', for example)
  helpers.create_augroup('netrw_delete_hidden', {
    {"FileType", "netrw", "setlocal bufhidden=delete"},
  })
end
configure_netrw()
-- }}}

-- visuals {{{
local function visuals_setup()
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
end
visuals_setup()
-- }}}

-- lsp diagnostics {{{
-- https://github.com/nvim-lua/diagnostic-nvim/issues/73
-- :help vim.lsp.diagnostic.on_publish_diagnostics
local function lsp_diagnostics_setup()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        -- spacing = 4,
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

  cmd('sign define LspDiagnosticsSignError text=🚨 texthl=LspDiagnosticsSignError linehl= numhl=')
  cmd('sign define LspDiagnosticsSignWarning text=⚠️ texthl=LspDiagnosticsSignWarning linehl= numhl=')
  cmd('sign define LspDiagnosticsSignInformation text=ℹ️ texthl=LspDiagnosticsSignInformation linehl= numhl=')
  cmd('sign define LspDiagnosticsSignHint text=💡 texthl=LspDiagnosticsSignHint linehl= numhl=')

  helpers.create_augroup('hover_lsp_diagnostics', {
    {"CursorHold", "*", "lua vim.lsp.diagnostic.show_line_diagnostics()"},
  })
end
lsp_diagnostics_setup()
-- }}}

-- plugin config {{{
require'plugin-config'

-- TODO exrc isn't working even if I change it to .nvimrc... doing this in the mean time
if filereadable('.vimrc') == 1 then
  cmd('source .vimrc')
end
-- }}}
