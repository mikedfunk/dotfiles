" vim: set foldmethod=marker ft=vim:
" my vim config

" Use plugins config {{{
runtime .vimrc.plugins.vim
" }}}

" Initialize directories {{{
" put everything in ~/.vim to avoid inline backup and swap files.
function! InitializeDirectories() abort
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
        \ 'backup': 'backupdir',
        \ 'views': 'viewdir',
        \ 'swap': 'directory'
    \ }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
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
set complete-=i
set smarttab

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

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

" if &listchars ==# 'eol:$'
"   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" endif

if v:version > 703 || v:version == 703 && has("patch541")
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

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
" if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
"   runtime! macros/matchit.vim
" endif

inoremap <C-U> <C-G>u<C-U>
" }}}

" General {{{
" use bram's defaults https://github.com/vim/vim/blob/master/runtime/defaults.vim
" unlet! skip_defaults_vim
" if filereadable($VIMRUNTIME . "/defaults.vim") | source $VIMRUNTIME/defaults.vim | endif
" set t_ut=
let g:mapleader = ',' " use comma for leader
" since , replaces leader, use \ to go back in a [f]ind
noremap \ ,
" set autoread " update files changed outside of vim. This works well with `set noswapfile`(in sensible.vim)
set exrc " enables reading .exrc or .vimrc from current directory
set secure " Always append set secure when exrc option is enabled!
set completeopt-=preview " turn off omnicomplete preview window
set completeopt+=longest " only autofill the common text between all completion options
set completeopt-=menu | set completeopt+=menuone " display completion even if there is one result. Useful for echodoc.
set ff=unix " Any non-unix line endings are converted to unix
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current
set ignorecase " Case insensitive search. Needed for smartcase to work.
set infercase " smarter, case-aware completion in insert mode.
set lazyredraw " to speed up rendering
set smartcase " Case sensitive when uc present
" https://vi.stackexchange.com/a/11413
au InsertEnter * set noignorecase
au InsertLeave * set ignorecase
set number " turn on line numbering
set iskeyword-=. " '.' is an end of word designator
set iskeyword-=- " '-' is an end of word designator
set tags=./.git/tags,./tags " avoid searching for other tags files
" set path=.,** " only search in git root
set path=** " only search in git root
" disabled due to this: Adding ** to 'path' is also a bad idea. Instead create a mapping that pre-fills :find **/, etc.
" set path+=** " search everywhere in current git root https://robots.thoughtbot.com/how-to-do-90-of-what-plugins-do-with-just-vim
set hlsearch " highlight search results
set modeline " enable modeline
set modelines=5 " enable modeline
set noshowmode " don't show the mode in the command area. it's already in airline.
" set synmaxcol=200 " avoid performance problems syntax highlighting very long lines
set ttyfast " speeds up terminal vim rendering
let g:PHP_outdentphpescape = 0 " means that PHP tags will match the indent of the HTML around them in files that a mix of PHP and HTML
let undodir="$HOME/.vimundo" | set undofile " persistent undo
set backupdir=$HOME/.vimbackup " set custom swap file dir
let viewdir="$HOME/.vimviews" " custom dir for :mkview output
" usage: :grep! my_term<cr>
if executable('ag')
    set grepprg=ag\ --vimgrep\ $* " allow :grep to use ag
    set grepformat=%f:%l:%c:%m " show column/row in results
    " note to self - try to use :grep! to keep it more vim-like.
    " command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw! " :Ag command that allows args
endif
set noswapfile " swap files are a pain in the ass. I have git.
" set nrformats= " make <C-a> and <C-x> play well with zero-padded numbers (i.e. don't consider them octal or hex)
set shortmess+=I " hide the launch screen
" set gdefault " search/replace 'globally' (on a line) by default NOTE: this just swaps the functionality of /g, so if you add /g it will only replace the first match :/ not what I expected

" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
" escape codes for italic fonts
set t_ZH=[3m
set t_ZR=[23m

" let php_baselib = 1 " highlight php builtin functions
" let g:php_folding = 1 " fold methods, control structures, etc.

" 'Rolodex Vim' http://vim.wikia.com/wiki/Window_zooming_convenience
" set noequalalways winminheight=0 winheight=9999 helpheight=9999

" auto open quickfix window on search if results found
augroup quickfixcmdgroup
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

if has("mouse")
    set mouse+=a " Automatically enable mouse usage
    set mousehide " Hide the mouse cursor while typing
endif
if &term =~ '^screen' " enable split dragging
    set ttymouse=sgr " @link https://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
    " set ttymouse=xterm2
endif
" if filereadable("cscope.out") && has('cscope')
"     cs add cscope.out
" endif

" Automatically equalize splits when Vim is resized https://vi.stackexchange.com/a/206/11130
augroup resizeequalize
    autocmd!
    autocmd VimResized * wincmd =
augroup END

" if the last window is a quickfix, close it
augroup quickfixclosegroup
    autocmd!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END

if has('clipboard')
    if has('unnamedplus') && !has('nvim')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else
        set clipboard=unnamed
    endif
endif

" https://vi.stackexchange.com/a/13012
" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

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
    autocmd BufRead,BufNewFile {haproxy.cfg,ssl-haproxy.cfg} set ft=haproxy
    autocmd BufRead,BufNewFile {site.conf,default.conf} set ft=nginx
    autocmd BufRead,BufNewFile {.curlrc,.gitignore,.gitattributes,.hgignore,.jshintignore} set ft=conf
    autocmd BufRead,BufNewFile .editorconfig set ft=dosini
    autocmd BufRead,BufNewFile .Brewfile set ft=sh
    autocmd BufRead,BufNewFile {.env,.env.*} set ft=dosini
augroup END

let g:netrw_liststyle=3 " tree style
" http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
noremap <c-e> :silent! Lex <C-R>=fnameescape(expand('%:h')).'/'<cr><cr>

" TIP: to cd to the directory of the current file:
" `:cd %%` (or on generic vim: `:cd %:p:h`)
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
    au!
    autocmd BufRead scp://* :set bt=acwrite
augroup END

" sublime-style filebrowser in sidebar workflow
"
" downside of this workflow is that if you :Le and move up a directory and
" open a file, then toggle :Le, it loses the reference to the explore window
" and opens another one. It's easier to just use vim-vinegar and just hit - to
" open the current dir in a split. Just use :Ex or :e . to open the :pwd in
" netrw.
"
" nerdtree-style browsing. Use P to open in previous window. :on to close explorer. <-- only works if you have no other splits open
" noremap <leader>nt :Lex %:p:h<cr>
" noremap <c-e> :Lex<cr>
" after opening the file browser with :Le , use this mapping to open the file in the previous split and close the explorer
" au! FileType netrw nmap <buffer> <leader>o <cr>:Lexplore<cr>

" Lexplore has a bug where if you change directories you can't :Lex to close
" it. This fixes it! https://www.reddit.com/r/vim/comments/6jcyfj/toggle_lexplore_properly/
" You still have to toggle netrw after browsing but enter opens in the
" previous split like NERDtree.
" let g:NetrwIsOpen=0
" function! ToggleNetrw(cmd)
"     if g:NetrwIsOpen
"         let i = bufnr("$")
"         while (i >= 1)
"             if (getbufvar(i, "&filetype") == "netrw")
"                 silent exe "bwipeout " . i
"             endif
"             let i-=1
"         endwhile
"         let g:NetrwIsOpen=0
"     else
"         let g:NetrwIsOpen=1
"         exec 'silent Lexplore' . a:cmd
"     endif
" endfunction
" noremap <c-e> :call ToggleNetrw('')<cr>
" noremap <leader>nt :call ToggleNetrw('%:p:h')<cr>

" open quickfix in vsplit, tab, split
augroup qfmaps
    autocmd!
    au FileType qf nmap <buffer> s <C-w><Enter>
    au FileType qf nmap <buffer> v <C-w><Enter><C-w>L
    au FileType qf nmap <buffer> t <C-W><Enter><C-W>T
    " move the quickfix to the bottom, stretched from left to right whenever
    " it opens. Without this, if you have 2 vertical splits and you grep
    " something, it will show up at the bottom of the current split only. This
    " is frustrating when you have 3 or 4 splits as it makes the results
    " difficult to read and navigate to.
    au FileType qf wincmd J
augroup END

" web-based documentation with shift-K
if executable('devdocs')
    augroup filetypesgroup
        autocmd!
        au FileType javascript set keywordprg=devdocs\ javascript
        au FileType html set keywordprg=devdocs\ html
        au FileType ruby set keywordprg=devdocs\ ruby
        au FileType css set keywordprg=devdocs\ css
    augroup END
endif

" line text object e.g. vil yil
xnoremap il 0o$h
onoremap il :normal vil<CR>

" TODO not working yet
" https://stackoverflow.com/questions/1694599/how-do-i-get-vims-sh-command-to-source-my-bashrc
" use my ~/.zshrc when running shell commands
" set shell=/usr/local/bin/zsh\ -l

" https://laracasts.com/series/vim-mastery/episodes/4#comment-2487013283
if has("gui_running")
    set macligatures
endif
" https://github.com/tonsky/FiraCode/issues/462
" set renderoptions=type:directx
" set encoding=utf-8
" }}}

" Completion {{{
if has("autocmd") && exists("+omnifunc")
    augroup omnifuncgroup
        autocmd!
        autocmd Filetype * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    augroup END
endif
augroup csscompletegroup
    autocmd!
    au FileType scss setlocal omnifunc=csscomplete#CompleteCSS
augroup END

set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico,*.pdf,*.psd,node_modules/*.git/*,Session.vim
" }}}

" Abbreviations {{{
" I am slow on the shift key
abbrev willREturn willReturn
abbrev shouldREturn shouldReturn
abbrev willTHrow willThrow
abbrev sectino section
abbrev colleciton collection

cabbr note: ~/Notes/
cabbrev snote: ~/Notes/saatchiart/
" }}}

" Mappings {{{
" @link https://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
" dare to dream a life without jj. It just makes it really difficult in any vim instance that's not using my vimrc.
" inoremap jj <esc>

" increment with c-b since I use c-a for tmux
" not needed now that I know - <prefix><prefix> sends <prefix> to the term from tmux!
" nnoremap <c-b> <c-a>
" vnoremap <c-b> <c-a>

" resize splits, consistent with tmux bindings
" nnoremap <c-w><s-j> :resize +10<cr> " this is also used to move the window to a vsplit on the bottom :/
" nnoremap <c-w><s-k> :resize -10<cr> " this is also used to move the window to a vsplit on the top :/
" nnoremap <c-w><s-l> :vertical resize +10<cr> " this is also used to move the window to a vsplit on the right :/
" nnoremap <c-w><s-h> :vertical resize -10<cr> " this is also used to move the window to a vsplit on the left :/

" in ex mode %% is current dir
cabbr <expr> %% expand('%:p:h')

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

" open tag in tab
nnoremap <silent><leader><c-]> <c-w><c-]><c-w>T
" open tag list in tab
nnoremap <silent><leader>g<c-]> mz:tabe %<cr>`z:exec("tselect ".expand("<cword>"))<cr>
nnoremap <silent><leader>g] mz:tabe %<cr>`z:exec("tselect ".expand("<cword>"))<cr>
nnoremap <silent><leader>g\ mz:tabe %<cr>`z:exec("tselect ".expand("<cword>"))<cr>
" open tag in vertical split
nnoremap <c-w><c-\> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>
" open tag list in vsplit
nnoremap <c-w>g<c-\> :vsp<CR>:exec("tselect ".expand("<cword>"))<CR>
nnoremap <c-w>g\ :vsp<CR>:exec("tselect ".expand("<cword>"))<CR>
" open tag list in hsplit
" <c-w>g<c-]>
nnoremap <c-w>vf :vertical wincmd f<cr>
command! -nargs=1 Vtselect vsp | exec 'tselect ' . <f-args> " like stselect but for vertical split e.g. :Vtselect /MyPartialTag

" stupid f1 help
nmap <f1> <nop>
imap <f1> <nop>

" switch to the last active tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
augroup tableavegroup
    autocmd!
    au TabLeave * let g:lasttab = tabpagenr()
augroup END

" format all
nnoremap <leader>fa mzggVG=`z :delmarks z<cr>hh :echo "formatted file"<cr>

" sort use statements alphabetically
augroup phpsortusegroup
    autocmd!
    au FileType php nnoremap <leader>su :call PhpSortUse()<cr>
augroup END

" array() to []
augroup phpfixarray
    autocmd!
    au FileType php nmap <leader>xa mv?array(f(mz%r]`zr[hvFa;d`v
augroup END

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
augroup phpexpendinterfacegroup
    autocmd!
    au FileType php command! PhpExpandInterfaceMethods :%s/\v(\w+\sfunction\s\w+\(.*\))(\: \w+)?;/\1\2\r    {\r        \/\/\r    }/g
    au FileType php nnoremap <leader>ei :PhpExpandInterfaceMethods<cr>
augroup END

" use vim grepprg
nnoremap <leader>gg :grep!<space>
" fzf provides this
" nnoremap <leader>gg :Ag<cr>

" fuzzy open
nnoremap <leader>xe :e **/*
nnoremap <leader>xt :tabe **/*
nnoremap <leader>xv :vsp **/*
nnoremap <leader>xs :sp **/*

" jump to tag
nnoremap <leader>je :tjump<space>
nnoremap <leader>js :sp tag<space>
nnoremap <leader>jv :vsp tag<space>
nnoremap <leader>jt :tab tag<space>

" poor man's vim-vinegar
nnoremap - :Ex<cr>

" open current file in browser (useful for markdown preview)
function! PreviewInBrowser() abort
    silent !open -a "Google Chrome" %:p
    redraw!
endfunction
command! PreviewInBrowser :call PreviewInBrowser()

" prefix php namespaces
function! PhpPrefixNamespaces() abort
    %s/@\([a-z]\+\) \([A-Z]\)/@\1 \\\2/g
    %s/@author \\/@author /g
    nohlsearch
endfunction
command! PhpPrefixNamespaces :call PhpPrefixNamespaces()
" }}}

" Visuals {{{
set background=dark
" set cursorline " highlight current line. this is really slow!
set colorcolumn=80,120 " show vert lines at the psr-2 suggested column limits
" silent! colorscheme lucius " set the default color scheme
if (isdirectory(expand("~/.vim/plugged/vim-hybrid-material")))
    silent! colorscheme hybrid_material
endif
let g:airline_theme = 'base16_ocean'
" let g:netrw_liststyle=3 " use netrw tree view by default (might cause this https://github.com/tpope/vim-vinegar/issues/13)
" set listchars=tab:▸•,eol:¬,trail:•,extends:»,precedes:«,nbsp:¬ " prettier hidden chars. turn on with :set list
set listchars=tab:▸•,trail:•,extends:»,precedes:« " prettier hidden chars. turn on with :set list (without line ending symbols)
augroup isbashgroup
    autocmd!
    au BufRead,BufNewFile *bash* let b:is_bash=1 " fix syntax highlighting for bash files
augroup END

let php_htmlInStrings = 1 " neat! :h php.vim

" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
augroup italic_comments_group
    autocmd!
    au FileType * hi! Comment cterm=italic
augroup END

augroup italic_comments_group_javascript
    autocmd!
    " jsdoc docblock @param, etc. in italic
    au FileType javascript hi! Special cterm=italic
augroup END

" Gui {{{
if has("gui_running") | set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h11 | endif
" }}}

" @link https://github.com/vim/vim/issues/981#issuecomment-241941032
" ensure tmux and terminal are set to screen-256color, then apply this for
" true color neovim and vim 8.0 that doesn't have background transparency
if (has('termguicolors'))
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
    set termguicolors
endif

" highlight the current line in yellow
command! HighlightLine :exe "let m = matchadd('WildMenu','\\%" . line('.') . "l')"
" clear all highlights for the current buffer only
command! ClearHighlights :call clearmatches() | IndentGuidesEnable

" }}}

" Commands and Functions {{{
augroup formattersgroup
    autocmd!
    " au FileType json command! FormatJSON %!python -m json.tool
    " au FileType json nnoremap <leader>fj :FormatJSON<cr>
    " use jdaddy instead! gqaj
    au FileType xml command! FormatXML %!xmllint --format --recover -
    au FileType xml nnoremap <leader>fx :FormatXML<cr>
augroup END
augroup gotousegroup
    autocmd!
    au FileType php command! GoToUseBlock execute ":normal! mmgg/use\ <cr>}:nohlsearch<cr>"
    " au FileType php nnoremap <leader>gu :GoToUseBlock<cr>
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
" }}}

" delete inactive buffers (the ones not in tabs or windows) {{{
" @link http://stackoverflow.com/a/7321131/557215
function! DeleteInactiveBufs() abort
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
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
    :normal! ggjddkOPdaWihttp://jj$daWojVGdkPGddO
endfunction
augroup headerstohttpgroup
    autocmd!
    au FileType rest command! HeadersToHttp :call HeadersToHttp()<cr>
augroup END
" }}}

" focus mode {{{
function! FocusModeToggle() abort
    if (&foldcolumn != 12)
        set showtabline=0
        set laststatus=0
        set foldcolumn=12
        set noruler
        hi FoldColumn ctermbg=none
        if (exists(':GitGutterDisable')) | :GitGutterDisable | endif
        let g:ale_sign_column_always=0
    else
        set showtabline=1
        set laststatus=2
        set foldcolumn=0
        set ruler
        if (exists(':GitGutterEnable')) | :GitGutterEnable | endif
        let g:ale_sign_column_always=1
    endif
endfunc
command! FocusModeToggle :call FocusModeToggle()
" }}}

" }}}

" Plugin Configuration {{{
runtime .vimrc.pluginconfig.vim
" }}}
