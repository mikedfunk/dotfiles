" vim config
" vim: set foldmethod=marker:
scriptencoding utf-8

" notes {{{
" my vim config. I currently divide this into 3 files:
"
" * ~/.vimrc - this file, which sets general vim|neovim settings. I bring this
" with me wish sshrc to have my basic vim settings with no plugins.
"
" * ~/.vim/.vimrc.plugins.vim - plugins I use, registered with vim-plug
"
" * ~/.vim/.vimrc.pluginconfig.vim - configuration for plugins only. This is
" kept separate because I usually adjust config and handle installed plugins
" separately. I don't want either to clutter up the other.
" }}}

" Use plugins config {{{
runtime .vimrc.plugins.vim
" }}}

" Initialize directories {{{
" (originally from spf13-vim)
" put everything in ~/.vim to avoid inline backup and swap files.
function! InitializeDirectories() abort
    let l:parent = $HOME
    let l:prefix = 'vim'
    let l:dir_list = {
        \ 'backup': 'backupdir',
        \ 'views': 'viewdir',
        \ 'swap': 'directory'
    \ }

    if has('persistent_undo')
        let l:dir_list['undo'] = 'undodir'
    endif

    let l:common_dir = l:parent . '/.' . l:prefix

    for [dirname, settingname] in items(l:dir_list)
        let directory = l:common_dir . dirname . '/'
        if exists('*mkdir')
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo 'Warning: Unable to create backup directory: ' . directory
            echo 'Try: mkdir -p ' . directory
        else
            let directory = substitute(directory, ' ', '\\\\ ', 'g')
            exec 'set ' . settingname . '=' . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }}}

" sensible.vim {{{
" Copied from sensible.vim so I don't need to install plugins to have basic sensible settings
" sensible.vim - Defaults everyone can agree on
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.2

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.

set autoindent
set backspace=indent,eol,start
" disable some completion sources for faster completion
set complete-=i " included files: prevent a condition where vim lags due to searching include files.
set complete-=t " tag completion
" set smarttab

set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set laststatus=2
set ruler
set wildmenu

" distance H goes from the top of screen (or L from bottom, or zt, zb)
if !&scrolloff
  " set scrolloff=1
  set scrolloff=3
endif

if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

" turn on relative line numbers unless I'm in terminal mode. In that case turn
" it off.
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &number | set relativenumber | endif
"   autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &number | set norelativenumber | endif
" augroup END

" above wasn't really needed and made pairing difficult
set relativenumber

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif
scriptencoding utf-8

" if &listchars ==# 'eol:$'
"   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" endif

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" improve syntax highlighting performance
" http://vim.wikia.com/wiki/Fix_syntax_highlighting
" https://stackoverflow.com/questions/4775605/vim-syntax-highlight-improve-performance
syntax sync minlines=200

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

inoremap <C-U> <C-G>u<C-U>
" }}}

" General {{{
" use bram's defaults https://github.com/vim/vim/blob/master/runtime/defaults.vim
" unlet! skip_defaults_vim
" if filereadable($VIMRUNTIME . "/defaults.vim") | source $VIMRUNTIME/defaults.vim | endif
if !has_key(g:plugs, 'vim-matchup')
    runtime macros/matchit.vim " jump to matching html tag (switched to vim-matchup)
endif
" runtime syntax/2html.vim
" set t_ut=
let g:mapleader = ',' " use comma for leader
" since , replaces leader, use \ to go back in a [f]ind
noremap \ ,
" set autoread " update files changed outside of vim. This works well with `set noswapfile`(in sensible.vim)
set exrc " enables reading .exrc or .vimrc from current directory
set secure " Always append set secure when exrc option is enabled!

" completeopt {{{
" completeopt default: 'menu,preview' :h completeopt
set completeopt-=preview " turn off omnicomplete preview window because it is a bit slow and flashes the completion tooltip between selections
" set completeopt+=longest " only autofill the common text between all completion options
" if !has('nvim')
"     set completeopt+=popup
" endif
if has('nvim')
    set pumblend=20 " pseudo-transparency in popups (neovim only)
endif
set completeopt+=noinsert,noselect " For as-you-type completion. avoids automatically inserting text as you type.
set completeopt-=menu | set completeopt+=menuone " display completion even if there is one result. Useful for as-you-type completion.
"
" all completeopt options:
" menu	    Use a popup menu to show the possible completions.  The
"      menu is only shown when there is more than one match and
"      sufficient colors are available.  |ins-completion-menu|

" menuone  Use the popup menu also when there is only one match.
"      Useful when there is additional information about the
"      match, e.g., what file it comes from.

" longest  Only insert the longest common text of the matches.  If
"      the menu is displayed you can use CTRL-L to add more
"      characters.  Whether case is ignored depends on the kind
"      of completion.  For buffer text the 'ignorecase' option is
"      used.

" preview  Show extra information about the currently selected
"      completion in the preview window.  Only works in
"      combination with 'menu' or 'menuone'.

" noinsert  Do not insert any text for a match until the user selects
"      a match from the menu. Only works in combination with
"      'menu' or 'menuone'. No effect if 'longest' is present.

" noselect  Do not select a match in the menu, force the user to
"      select one from the menu. Only works in combination with
"      'menu' or 'menuone'.

" }}}

set fileformat=unix " Any non-unix line endings are converted to unix
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current
set ignorecase " Case insensitive search. Needed for smartcase to work.
set infercase " smarter, case-aware completion in insert mode.
set lazyredraw " to speed up rendering and avoid scrolling problems
set smartcase " Case sensitive when uc present
" NOTE this results in an extra split showing up below the quickfix for some reason - I think because it overlaps with fzf-vim's mappings
" set switchbuf=usetab,newtab " when following quickfix results, jump to first tab/window that has that file open if any. Also works with :sb
" https://vi.stackexchange.com/a/11413
augroup ignorecase_augroup
    autocmd!
    autocmd InsertEnter * set noignorecase
    autocmd InsertLeave * set ignorecase
augroup END
set number " turn on line numbering
set iskeyword-=. " '.' is an end of word designator
set iskeyword-=- " '-' is an end of word designator
" set tags=./.git/tags,./tags " avoid searching for other tags files
set tags=./tags " avoid searching for other tags files
" set path=.,** " only search in git root
set path=** " only search in git root
" disabled due to this: Adding ** to 'path' is also a bad idea. Instead create a mapping that pre-fills :find **/, etc.
" set path+=** " search everywhere in current git root https://robots.thoughtbot.com/how-to-do-90-of-what-plugins-do-with-just-vim
" turning this off but keeping incsearch on so I can use search for navigation
" more easily on recommendation from practical vim
" set hlsearch " highlight search results
set nohlsearch " highlight search results
set modeline " enable modeline
set modelines=5 " enable modeline
set noshowmode " don't show the mode in the command area. it's already in airline.
set ttyfast " speeds up terminal vim rendering
if !has('nvim')
    set ttyscroll=3 " faster scrolling
endif
let undodir='$HOME/.vimundo' | set undofile " persistent undo
set backupdir=$HOME/.vimbackup " set custom swap file dir
let viewdir='$HOME/.vimviews' " custom dir for :mkview output
" usage: :grep! my_term<cr>
if executable('ag')
    set grepprg=ag\ --vimgrep " allow :grep to use ag (man ag)
    set grepformat=%f:%l:%c%m " show column/row in results
    " note to self - try to use :grep! to keep it more vim-like.
    " command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw! " :Ag command that allows args
elseif executable('git')
    " git grep is much faster than regular grep
    set grepprg=git\ --no-pager\ grep\ --no-color\ -rin
    set grepformat=%f:%l:%m,%m\ %f\ match%ts,%f
endif
set noswapfile " swap files are a pain in the ass. I have git.
" set nrformats= " make <C-a> and <C-x> play well with zero-padded numbers (i.e. don't consider them octal or hex)
set shortmess+=I " hide the launch screen
try
    set shortmess+=c " hide 'back at original', 'match (x of x)', etc.
catch /E539: Illegal character/
endtry
" set gdefault " search/replace 'globally' (on a line) by default NOTE: this just swaps the functionality of /g, so if you add /g it will only replace the first match :/ not what I expected

" Keep the cursor on the same column
set nostartofline

" Shift-tab on GNU screen
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

" escape codes for italic fonts
" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
let &t_ZH="\<Esc>[3m"
let &t_ZR="\<Esc>[23m"

" php settings {{{
let g:PHP_removeCRwhenUnix = 1
let g:PHP_outdentphpescape = 0 " means that PHP tags will match the indent of the HTML around them in files that a mix of PHP and HTML
let g:php_htmlInStrings = 1 " neat! :h php.vim
let g:php_baselib = 1 " highlight php builtin functions
" let g:php_folding = 1 " fold methods, control structures, etc.
let g:php_noShortTags = 1
" let g:php_parent_error_close = 1 " highlight missing closing ] or )
" let g:php_parent_error_open = 1 " highlight missing opening [ or (
let g:php_syncmethod = 10 " :help :syn-sync https://stackoverflow.com/a/30732393/557215
" doxygen support is _extremely_ buggy for php.
" e.g. if you go to the last curly brace in a class, it breaks syntax
" highlighting for one page above that class :/
" :h doxygen
" let g:load_doxygen_syntax = 1 " pretty docblocks in php, c, etc.
" let g:doxygen_my_rendering = 0 " Q: does this fix it? I doubt it. A: nope.
" let g:doxygen_enhanced_color = 1 " prettier docblocks

" augroup phpfoldnestmax
"     autocmd!
"     " start out with php methods folded
"     " only fold methods in php - not structures, etc.
"     autocmd FileType php set foldlevelstart=1 foldnestmax=1
" augroup END
" }}}

" 'Rolodex Vim' http://vim.wikia.com/wiki/Window_zooming_convenience
" set noequalalways winminheight=0 winheight=9999 helpheight=9999

" auto open quickfix window on search if results found
" augroup quickfixcmdgroup
"     autocmd!
"     autocmd QuickFixCmdPost *grep* copen
" augroup END
"
augroup quickfixopengroup
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

if has('mouse')
    set mouse+=a " Automatically enable mouse usage
    set mousehide " Hide the mouse cursor while typing
endif
if &term =~# '^screen' " enable split dragging
    set ttymouse=sgr " @link https://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
    " set ttymouse=xterm2
endif

" cscope {{{
" http://vim.wikia.com/wiki/Cscope
if has('cscope')
    " NOTE: gutentags handles generating and adding the cscope db
    " recommended here to improve cscope quickfix results
    " https://www.reddit.com/r/vim/comments/95jxk7/big_list_of_tagsctags_matches_how_to_navigate_in/
    " set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
    set cscopetag " use cscope db as well as tags db for tag operations
    " set nocscopetag " use cscope db as well as tags db for tag operations

    " open usage list here
    nnoremap <c-\> :exec("cscope find c ".expand("<cword>"))<cr>
    " open usage list in vertical split
    nnoremap <c-w><c-\> :vsp<CR>:exec("cscope find c ".expand("<cword>"))<cr>
    " I don't use horizontal splits much... but if I need it I can just `:scs find c something`
    " open usage list in new tab
    function! FindUsagesInNewTab () abort
        :normal! mz
        :tabe %
        :normal! `z
        :exec("cscope find c ".expand('<cword>'))
    endfunction
    nnoremap <silent><leader><c-\> :call FindUsagesInNewTab()<cr>

    " can also :cs find {type} {string}
    " types:
    " 0 or s: Find this C symbol
    " 1 or g: Find this definition
    " 2 or d: Find functions called by this function
    " 3 or c: Find functions calling this function
    " 4 or t: Find this text string
    " 6 or e: Find this egrep pattern
    " 7 or f: Find this file
    " 8 or i: Find files #including this file
    " 9 or a: Find places where this symbol is assigned a value
    "
    " really I don't see the point of any of these except 'c'
endif
" }}}

" Automatically equalize splits when Vim is resized https://vi.stackexchange.com/a/206/11130
augroup resizeequalize
    autocmd!
    autocmd VimResized * wincmd =
augroup END

" if the last window is a quickfix, close it
augroup quickfixclosegroup
    autocmd!
    autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END

" use system clipboard. If this isn't here you have to \"* before every
" yank/delete/paste command. Really annoying. Leader commands are tricky too
" if you want to make them work with motions and visual selections.
if has('clipboard')
    if has('unnamedplus') && !has('nvim')  " When possible use + register for copy-paste
        set clipboard^=unnamedplus
    else
        set clipboard=unnamed
    endif
endif

" https://vi.stackexchange.com/a/13012
" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
augroup netrw_delete_hidden_augroup
    autocmd!
    autocmd FileType netrw setl bufhidden=delete
augroup END

" this is because some of my notes start with 'vim:'
augroup disable_modeline_for_markdown
    autocmd!
    autocmd FileType markdown :set nomodeline
augroup END

" if I don't do this it's disabled for pinfo files for some reason
augroup enable_modeline_for_pinfo
    autocmd!
    autocmd FileType pinfo :set modeline
augroup END

" disable Ex mode
nnoremap Q <nop>

" packadd! matchit " use the included matchit plugin (already loaded by vim-sensible)

" set filetypes for unusual files
augroup filetypessetgroup
    autocmd!
    autocmd BufRead,BufNewFile *.phtml set ft=phtml.html
    autocmd BufRead,BufNewFile *.eyaml set ft=yaml
    autocmd BufRead,BufNewFile .babelrc set ft=json
    autocmd BufRead,BufNewFile .php_cs set ft=php
    autocmd BufRead,BufNewFile *.php.sample set ft=php
    autocmd BufRead,BufNewFile *.php.dist set ft=php
    autocmd BufRead,BufNewFile {haproxy.cfg,ssl-haproxy.cfg} set ft=haproxy
    autocmd BufRead,BufNewFile {site.conf,default.conf} set ft=nginx
    autocmd BufRead,BufNewFile {.curlrc,.gitignore,.gitattributes,.hgignore,.jshintignore} set ft=conf
    autocmd BufRead,BufNewFile .editorconfig set ft=dosini
    autocmd BufRead,BufNewFile .myclirc* set ft=dosini
    autocmd BufRead,BufNewFile .Brewfile set ft=sh
    autocmd BufRead,BufNewFile .sshrc set ft=sh
    autocmd BufRead,BufNewFile .tigrc set ft=gitconfig
    autocmd BufRead,BufNewFile {.env,.env.*} set ft=dosini
    autocmd BufRead,BufNewFile *.cnf set ft=dosini
    autocmd BufRead,BufNewFile .spacemacs set ft=lisp
augroup END

let g:netrw_liststyle=3 " tree style
" http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
noremap <c-e> :silent! Lex <C-R>=fnameescape(expand('%:h')).'/'<cr><cr>

" TIP: to cd to the directory of the current file:
" `:cd %%` (or on generic vim: `:cd %:h`)
" Then to cd back to git root:
" `:Gcd` (or `:cd -`)
" Useful for <c-x><c-f> for javascript imports
" Also you can <c-o> when in insert mode to temporarily run commands and jump
" back to insert mode when done

let g:netrw_localrmdir='rm -r' " Allow netrw to remove non-empty local directories
let g:netrw_winsize = -40 " percent of the split size for :Sex and :Vex . Negative means use absolute column width.
let g:netrw_banner = 0 " remove that silly shortcut banner/header at the top, even without vim-vinegar
" https://github.com/vim/vim/issues/2329#issuecomment-350294641
augroup netrw_fix
    autocmd!
    autocmd BufRead,BufWritePost scp://* :set bt=acwrite
augroup END

" open quickfix in vsplit, tab, split
augroup qfmaps
    autocmd!
    autocmd FileType qf nmap <buffer> s <C-w><Enter>
    autocmd FileType qf nmap <buffer> v <C-w><Enter><C-w>L
    autocmd FileType qf nmap <buffer> t <C-W><Enter><C-W>T
    " move the quickfix to the bottom, stretched from left to right whenever
    " it opens. Without this, if you have 2 vertical splits and you grep
    " something, it will show up at the bottom of the current split only. This
    " is frustrating when you have 3 or 4 splits as it makes the results
    " difficult to read and navigate to.
    autocmd FileType qf wincmd J
augroup END

" web-based documentation with shift-K
" https://www.reddit.com/r/vim/comments/3oo1e0/has_anyone_found_a_way_to_make_k_useful/
" NOTE: keywordprg is not invoked silently, so you will get 'press enter to
" continue'
if executable('devdocs')
    augroup filetypesgroup
        autocmd!
        autocmd FileType php set keywordprg=devdocs\ php
        autocmd FileType javascript* set keywordprg=devdocs\ javascript
        autocmd FileType html set keywordprg=devdocs\ html
        autocmd FileType ruby set keywordprg=devdocs\ ruby
        autocmd FileType css* set keywordprg=devdocs\ css
        autocmd FileType zsh set keywordprg=devdocs\ bash
        autocmd FileType bash set keywordprg=devdocs\ bash
        autocmd FileType sh set keywordprg=devdocs\ bash
    augroup END
endif

" do not conceal anything when cursor is over a line
set concealcursor=

" line text object e.g. vil yil
xnoremap il 0o$h
onoremap il :normal vil<CR>

" https://laracasts.com/series/vim-mastery/episodes/4#comment-2487013283
if has('gui_running')
    set macligatures
endif
" https://github.com/tonsky/FiraCode/issues/462
" set renderoptions=type:directx
" set encoding=utf-8

" avoid python deprecation warnings
" https://github.com/vim/vim/issues/3117#issuecomment-402622616
if has('python3')
    silent! python3 1
endif

" for python2 (just to make :check happy)
if executable('/usr/local/bin/python2')
    let g:python_host_prog = '/usr/local/bin/python2'
endif

" preview susbstitute in neovim
" https://dev.to/petermbenjamin/comment/7ng0
if has('nvim')
    set inccommand=split
    " set inccommand=nosplit
endif

" https://blog.kdheepak.com/three-built-in-neovim-features.html#highlight-yanked-text
if has('nvim')
    augroup LuaHighlight
        autocmd!
        autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
    augroup END
endif

if has('nvim')
    set diffopt+=hiddenoff " Do not use diff mode for a buffer when it becomes hidden
endif
if filereadable('/usr/share/dict/words')
    set dictionary+=/usr/share/dict/words " Make <c-o><c-k> complete English words
endif

" Why is this not a built-in Vim script function?!
function! GetVisualSelection() abort
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" remove the $ sign from what consitutes a 'word' in vim
" TODO I think this is being assigned in a plugin. Track it down at the source
" instead of fixing it here.
augroup dollarsignphp
    autocmd!
    autocmd FileType php set iskeyword -=$
augroup END

" }}}

" Completion {{{
if has('autocmd') && exists('+omnifunc')
    augroup omnifuncgroup
        autocmd!
        autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    augroup END
endif
augroup csscompletegroup
    autocmd!
    autocmd FileType scss setlocal omnifunc=csscomplete#CompleteCSS
augroup END

set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico,*.pdf,*.psd,node_modules/*,.git/*,Session.vim
set wildoptions+=tagfile " When using CTRL-D to list matching tags, the kind of tag and the file of the tag is listed.	Only one match is displayed per line.

" auto close preview when completion is done {{{
augroup auto_close_completion_preview
    autocmd!
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
" }}}

" tab completion {{{
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" this is already handled by autopairs, adding it again breaks it
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
" }}}

" }}}

" Abbreviations {{{
" I am slow on the shift key
abbrev willREturn willReturn
abbrev shouldREturn shouldReturn
abbrev willTHrow willThrow
abbrev sectino section
abbrev colleciton collection
abbrev Colleciton Collection
abbrev leagcy legacy
abbrev Leagcy Legacy

cabbr note: ~/Notes/
cabbrev snote: ~/Notes/saatchiart/
" }}}

" Mappings {{{
" @link https://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~# '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" in ex mode %% is current dir
cabbr <expr> %% expand('%:p:h')

" from practical vim recommendation
cnoremap <c-p> <Up>
cnoremap <c-n> <Down>

" nnoremap <leader>tt :tabe<cr>

" put cursor at end of text on y and p
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Wrapped lines goes down/up to next row, rather than next line in file.
" noremap j gj
" noremap k gk
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Easier horizontal scrolling
map zl zL
map zh zH

" my version of fast tabs. Doesn't work in netrw tabs.
nnoremap gh gT
nnoremap gl gt
nnoremap <c-w>t :tabe<cr>

" for all tag jumps, show the menu when there are more than one result! if
" only one result, jump away. :h tjump. I don't see why I would want to do it
" any other way!! The default sucks - it sometimes takes me to the wrong match
" because it's the first match.
nnoremap <c-]> :exec("tjump ".expand("<cword>"))<cr>
" open tag in tab
" this should really just be <c-w>g<c-]> then <c-w>T but I couldn't get that
" to work
function! OpenTagInNewTab () abort
    :normal! mz
    :tabe %
    :normal! `z
    :exec("tjump ".expand('<cword>'))
endfunction
nnoremap <silent><leader><c-]> :call OpenTagInNewTab()<cr>
" open tag in vertical split
" nnoremap <c-w><c-]> :exec("stjump ".expand("<cword>"))<CR>
nnoremap <c-w><c-]> :vsp<CR>:exec("tjump ".expand("<cword>"))<CR>
" open tag in preview window (<c-w><c-z> to close)
nnoremap <c-w>} :exec("ptjump ".expand("<cword>"))<CR>
command! -nargs=1 Vtselect vsp | exec 'tselect ' . <f-args> " like stselect but for vertical split e.g. :Vtselect /MyPartialTag

" stupid f1 help
nmap <f1> <nop>
imap <f1> <nop>

" maximize height of split - useful for vdebug especially
" nnoremap <leader>++ :resize 999<cr>

" switch to the last active tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
augroup tableavegroup
    autocmd!
    autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END

" format all
nnoremap <leader>fa mzggVG=`z :delmarks z<cr>hh :echo "formatted file"<cr>

" sort use statements alphabetically
augroup phpsortusegroup
    autocmd!
    autocmd FileType php nnoremap <leader>su :call PhpSortUse()<cr>
augroup END

" single line to multiline docblock
function PhpSingleToMultiDocblock() abort
    :.,.s/\/\*\* \(.*\) \*\//\/\*\*\r     * \1\r     *\//g
endfunction
augroup phpsingletomultilinedocblockgroup
    autocmd!
    autocmd FileType php nnoremap <leader>cm :call PhpSingleToMultiDocblock()<cr>
augroup END

" array() to []
augroup phpfixarray
    autocmd!
    autocmd FileType php nmap <leader>xa mv?array(f(mz%r]`zr[hvFa;d`v
augroup END

" when copying methods over to an interface this turns them to the signature
" version
" e.g.
" public function myMethod($whatever): string
" {
"     // ...
" }
" to:
" public function myMethod($whatever): string;
"
function! PhpMethodsToInterfaceSignatures() abort
    :%g/    public function/normal! jd%kA;
    :nohlsearch
endfunction

augroup phphelpersgroup
    autocmd!
    " when copying php interface methods over, this turns interface stubs into
    " empty php methods. e.g. turns
    " public function myMethod($whatever);
    " or
    " public function myMethod($whatever): MyReturnValue;
    " into
    " public function myMethod($whatever)
    " or
    " public function myMethod($whatever): MyReturnValue
    " {
    "     //
    " }
    autocmd FileType php command! PhpExpandInterfaceMethods :%s/\v(\w+\sfunction\s\w+\(.*\))(\: \w+)?;/\1\2\r    {\r        \/\/\r    }/g
    autocmd FileType php nnoremap <leader>ei :PhpExpandInterfaceMethods<cr>
    autocmd FileType php command! PhpMethodsToInterfaceSignatures :call PhpMethodsToInterfaceSignatures()
    autocmd FileType php nnoremap <leader>em :PhpMethodsToInterfaceSignatures<cr>
    function! PhpToggleFolding () abort
        if g:php_folding
            :let g:php_folding = 0
        else
            :let g:php_folding = 1
        endif
        :e!
    endfunction
    autocmd FileType php command! PhpToggleFolding :call PhpToggleFolding()
augroup END

" use vim grepprg
" This has a nasty bug in neovim where the quickfix height is incorrect,
" eventually causing it to crash. I had to disable it because I was tired of
" dealing with this crap.
" https://github.com/neovim/neovim/issues/11580
" https://github.com/neovim/neovim/issues/11424
" https://stackoverflow.com/a/39010855/557215
" nnoremap <leader>gg :silent grep!<space>
" nnoremap <leader>gg :grep!<space>
"
" fzf version to avoid neovim bug with quickfix populating fucking everything up (downside - can't add ag args)
" nnoremap <leader>gg :Ag<cr>
"
" AsyncRun version to keep it in the quickfix but avoid the neovim quickfix
" population bug
" (moved to .vimrc.pluginconfig.vim)

" pneumonic: grep all
" nnoremap <leader>ga :grep!
"             \ --skip-vcs-ignores
"             \ --ignore="autoload.*"
"             \ --ignore="tags"
"             \ --ignore="tags*"
"             \ --ignore="cscope*"
"             \ --ignore="ncscope*"
"             \ --ignore="Session.vim"
"             \ --ignore="boostrap/cache"
"             \ --ignore="sessions"<space>
nnoremap <leader>wg :grep! <cword> .<cr>
nnoremap <leader>Wg :grep! '\b<cword>\b' .<cr>
" fzf provides this
" nnoremap <leader>gg :Ag<cr>

" fuzzy open
nnoremap <leader>fe :e **/*
nnoremap <leader>ft :tabe **/*
nnoremap <leader>fv :vsp **/*
nnoremap <leader>fs :sp **/*

" jump to tag
nnoremap <leader>je :tjump<space>
" nnoremap <leader>js :sp<CR>:tag<space>
nnoremap <leader>jv :vsp<CR>:tag<space>
nnoremap <leader>jt :tabe<CR>:tag<space>

" diffs
nnoremap <leader>dr :diffget REMOTE<cr>
nnoremap <leader>dl :diffget LOCAL<cr>

" poor man's vim-vinegar
" The thing I hate about this is that it doesn't preserve the last line it was
" on, so I often have to scroll back down. Vinegar does this. TODO look at
" vinegar's code for this since that's the only thing I really use in vinegar
" that I can't get with netrw config.
" nnoremap - :Ex<cr>

" open current file in browser (useful for markdown preview)
function! PreviewInBrowser() abort
    " silent !open -a "Google Chrome" %:p
    silent !open -a "Firefox" %:p
    redraw!
endfunction
command! PreviewInBrowser :call PreviewInBrowser()

" prefix php namespaces
function! PhpPrefixNamespaces() abort
    silent! %s/@\([a-z]\+\) \([A-Z]\)/@\1 \\\2/g
    silent! %s/@author \\/@author /g
    nohlsearch
endfunction
command! PhpPrefixNamespaces :call PhpPrefixNamespaces()

" http://vim.wikia.com/wiki/Highlight_current_line
nnoremap <silent> <leader>hl ml:execute 'match Search /\%'.line('.').'l/'<CR>
" `:match` to clear highlighting when finished
" }}}

" Visuals {{{
set redrawtime=10000 " avoid problem with losting syntax highlighting https://github.com/vim/vim/issues/2790#issuecomment-400547834
set background=dark
" set cursorline " highlight current line. this is really slow!
set colorcolumn=80,120 " show vert lines at the psr-2 suggested column limits
" let g:netrw_liststyle=3 " use netrw tree view by default (might cause this https://github.com/tpope/vim-vinegar/issues/13)
" set listchars=tab:▸•,eol:¬,trail:•,extends:»,precedes:«,nbsp:¬ " prettier hidden chars. turn on with :set list
set listchars=nbsp:␣,tab:▸•,eol:↲,trail:•,extends:»,precedes:«,trail:• " prettier hidden chars. turn on with :set list or yol (different symbols)
" set listchars=nbsp:␣,tab:▸•,trail:•,extends:»,precedes:«,trail:• " (like above without line ending symbols)

" show leading spaces
" (messes up Yggdroot/indentLine)
" https://www.reddit.com/r/vim/comments/b8wbzb/shows_tabs_and_spaces_as_dots_in_vim_like_sublime/
" hi Conceal guibg=NONE ctermbg=NONE ctermfg=DarkGrey
" augroup showleadingspaces
"     autocmd!
"     autocmd BufRead * setlocal conceallevel=2 concealcursor=nv
"     autocmd BufRead * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·
" augroup end

augroup isbashgroup
    autocmd!
    autocmd BufRead,BufNewFile *bash* let b:is_bash=1 " fix syntax highlighting for bash files
augroup END

" do not conceal quotes and stuff on the current line! Why would I even want
" that?? It's worse than no formatting if I can't even see the quotes.
" NOTE this is set by indentLine plugin to allow indent lines. See https://github.com/Yggdroot/indentLine
" Now commented out because `let g:vim_json_syntax_conceal = 0` covers it
" augroup jsonformat
"     autocmd!
"     autocmd FileType json set concealcursor-=n
"     " jsonc - json with // comments
"     autocmd FileType json syntax match Comment +\/\/.\+$+
" augroup END

" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
function! ItalicComments() abort
    hi! Comment cterm=italic, gui=italic
    " these mess up doxygen colors :(
    " hi! doxygenSpecial cterm=italic gui=italic
    " hi! doxygenOther cterm=italic, gui=italic
    " hi! doxygenSpecialOnelineDesc cterm=italic, gui=italic
    " hi! doxygenSpecialTypeOnelineDesc cterm=italic, gui=italic
    " hi! doxygenStart cterm=italic, gui=italic
    " hi! doxygenStartSpecial cterm=italic, gui=italic
    " hi! doxygenComment cterm=italic, gui=italic
    " hi! doxygenBody cterm=italic, gui=italic
    " hi! doxygenBOther cterm=italic, gui=italic
endfunction
augroup italic_comments_group
    autocmd!
    autocmd FileType * call ItalicComments()
augroup END

augroup italic_comments_group_javascript
    autocmd!
    " jsdoc docblock @param, etc. in italic
    autocmd FileType javascript hi! Special cterm=italic
augroup END

" Gui {{{
if has('gui_running') | set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h11 | endif
" }}}

" @link https://github.com/vim/vim/issues/981#issuecomment-241941032
" ensure tmux and terminal are set to screen-256color, then apply this for
" true color neovim and vim 8.0 that doesn't have background transparency
" (uses escape character ^[)
if (has('termguicolors'))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    " neovim bug: if you enable termguicolors it disables italics :/
    set termguicolors
endif

" highlight the current line in yellow
command! HighlightLine :exe "let m = matchadd('WildMenu','\\%" . line('.') . "l')"
" clear all highlights for the current buffer only
command! ClearHighlights :call clearmatches() | IndentGuidesEnable

" underline lsp errors
" https://old.reddit.com/r/neovim/comments/fw7qj0/the_new_builtin_lsp_support_is_so_awesome/
augroup neovim_lsp_colors
    autocmd!
    autocmd ColorScheme * hi! link LspDiagnosticsUnderlineError SpellCap
    autocmd ColorScheme * hi! link LspDiagnosticsUnderlineWarning SpellBad
    autocmd ColorScheme * hi! link LspDiagnosticsUnderlineHint SpellRare
    autocmd ColorScheme * hi! link LspDiagnosticsUnderlineInformation SpellRare
augroup END

" TIP: z= will show spell completion options. zg will add the word to the
" spelling library. zw will mark a word as incorrect spelling. set spell or
" yos will toggle spellcheck. ]s [s will go to next/prev spell error.
set spelllang=en_us
" }}}

" Navigation and Search {{{
augroup folding_for_some_filetypes
    autocmd!
    autocmd FileType json setlocal foldmethod=indent
    autocmd FileType yaml setlocal foldmethod=indent
augroup END
" }}}

" Commands and Functions {{{
augroup formattersgroup
    autocmd!
    " autocmd FileType json command! FormatJSON %!python -m json.tool
    " autocmd FileType json nnoremap <leader>fj :FormatJSON<cr>
    " use jdaddy instead! gqaj
    autocmd FileType xml command! FormatXML %!xmllint --format --recover -
    autocmd FileType xml nnoremap <leader>fx :FormatXML<cr>
augroup END
augroup gotousegroup
    autocmd!
    autocmd FileType php command! GoToUseBlock execute ":normal! mmgg/use\ <cr>}:nohlsearch<cr>"
    " autocmd FileType php nnoremap <leader>gu :GoToUseBlock<cr>
augroup END
command! Source :source ~/.vimrc | if filereadable('.vimrc') | :source .vimrc | endif | AirlineRefresh
nnoremap <leader>so :Source<cr>

" fix syntax highlighting when it goes away
command! FixSyntax :filetype detect

" fix issue with netrw {{{
" https://github.com/tpope/vim-vinegar/issues/13#issuecomment-315584214
augroup netrw_buf_hidden_fix
    autocmd!
    " Set all non-netrw buffers to bufhidden=hide
    autocmd BufWinEnter *
                \  if &ft != 'netrw'
                \|     set bufhidden=hide
                \| endif
augroup end

" tmux complete {{{
" https://github.com/junegunn/dotfiles/blob/5a152686a9456e3713c5b0d4abc7798607db1979/vimrc
function! s:tmux_feedkeys(data)
echom empty(g:_tmux_q)
execute 'normal!' (empty(g:_tmux_q) ? 'a' : 'ciW')."\<C-R>=a:data\<CR>"
startinsert!
endfunction

function! s:tmux_words(query)
let g:_tmux_q = a:query
let matches = fzf#run({
\ 'source':      'tmuxwords.rb --all-but-current --scroll 500 --min 5',
\ 'sink':        function('s:tmux_feedkeys'),
\ 'options':     '--no-multi --query='.a:query,
\ 'tmux_height': '40%'
\ })
endfunction

inoremap <silent> <C-X><C-T> <C-o>:call <SID>tmux_words(expand('<cWORD>'))<CR>
" }}}

" }}}

" delete inactive buffers (the ones not in tabs or windows) {{{
" @link http://stackoverflow.com/a/7321131/557215
function! DeleteInactiveBufs() abort
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let l:tablist = []
    for l:i in range(tabpagenr('$'))
        call extend(l:tablist, tabpagebuflist(l:i + 1))
    endfor

    let l:nWipeouts = 0
    for l:i in range(1, bufnr('$'))
        if bufexists(l:i) && !getbufvar(l:i,'&mod') && index(l:tablist, l:i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' l:i
            let l:nWipeouts = l:nWipeouts + 1
        endif
    endfor
    echomsg l:nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
" }}}

" profiler {{{
" to see what is causing vim to slow down
function! StartProfiler() abort
    profile start profile.log
    profile func *
    profile file *
    " At this point do slow actions
endfunction
command! StartProfiler :call StartProfiler()

function! EndProfiler() abort
    profile pause
    noautocmd qall!
endfunction
command! EndProfiler :call EndProfiler()
" }}}

" json to php array {{{
function! JsonToPhp() abort
    :%s/":"/" => "/ge | %s/":{/" => [/ge | %s/":\[/" => [/ge | %s/{/[/ge | %s/}/]/ge
endfunction
command! JsonToPhp :call JsonToPhp()<cr>
" }}}

" convert copied chrome headers to http request {{{
function! HeadersToHttp() abort
    :normal! ggjddkOPdaWihttp://jj$daWojVGdkPGddOGA?XDEBUG_SESSION_START=mikedfunkxd
endfunction
augroup headerstohttpgroup
    autocmd!
    autocmd FileType rest command! HeadersToHttp :call HeadersToHttp()<cr>
augroup END
" }}}

" get todos in git working area {{{
" https://github.com/junegunn/dotfiles/blob/5a152686a9456e3713c5b0d4abc7798607db1979/vimrc#L785
function! s:todo() abort
let entries = []
for cmd in ['git grep -n -e TODO -e FIXME -e XXX 2> /dev/null',
          \ 'grep -rn -e TODO -e FIXME -e XXX * 2> /dev/null']
  let lines = split(system(cmd), '\n')
  if v:shell_error != 0 | continue | endif
  for line in lines
    let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
    call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
  endfor
endfor

if !empty(entries)
  call setqflist(entries)
  copen
endif
endfunction
command! Todo call s:todo()
" }}}

" }}}

" Plugin Configuration {{{
runtime .vimrc.pluginconfig.vim
" }}}
