" vim: set foldmethod=marker ft=vim:
" my vim config

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
set complete-=i " included files
set complete-=t " tag completion
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
" set synmaxcol=200 " avoid performance problems syntax highlighting very long lines

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
runtime macros/matchit.vim " jump to matching html tag
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
set fileformat=unix " Any non-unix line endings are converted to unix
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current
set ignorecase " Case insensitive search. Needed for smartcase to work.
set infercase " smarter, case-aware completion in insert mode.
set lazyredraw " to speed up rendering and avoid scrolling problems
set smartcase " Case sensitive when uc present
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
set modeline " enable modeline
set modelines=5 " enable modeline
set noshowmode " don't show the mode in the command area. it's already in airline.
set ttyfast " speeds up terminal vim rendering
set ttyscroll=3 " faster scrolling
let undodir='$HOME/.vimundo' | set undofile " persistent undo
set backupdir=$HOME/.vimbackup " set custom swap file dir
let viewdir='$HOME/.vimviews' " custom dir for :mkview output
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
augroup quickfixcmdgroup
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

if has('mouse')
    set mouse+=a " Automatically enable mouse usage
    set mousehide " Hide the mouse cursor while typing
endif
if &term =~# '^screen' " enable split dragging
    set ttymouse=sgr " @link https://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
    " set ttymouse=xterm2
endif
" if filereadable("cscope.out") && has('cscope')
"     cs add cscope.out
" endif

" if has('cscope')
    " recommended here to improve cscope quickfix results
    " https://www.reddit.com/r/vim/comments/95jxk7/big_list_of_tagsctags_matches_how_to_navigate_in/
    " set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
" endif

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
    autocmd BufRead,BufNewFile .myclirc* set ft=dosini
    autocmd BufRead,BufNewFile .Brewfile set ft=sh
    autocmd BufRead,BufNewFile .sshrc set ft=sh
    autocmd BufRead,BufNewFile .tigrc set ft=gitconfig
    autocmd BufRead,BufNewFile {.env,.env.*} set ft=dosini
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
" autocmd! FileType netrw nmap <buffer> <leader>o <cr>:Lexplore<cr>

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
if executable('devdocs')
    augroup filetypesgroup
        autocmd!
        autocmd FileType javascript set keywordprg=devdocs\ javascript
        autocmd FileType html set keywordprg=devdocs\ html
        autocmd FileType ruby set keywordprg=devdocs\ ruby
        autocmd FileType css set keywordprg=devdocs\ css
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
if &term =~# '^screen'
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

" from practical vim recommendation
cnoremap <c-p> <Up>
cnoremap <c-n> <Down>

nnoremap <leader>tt :tabe<cr>

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
augroup END

" use vim grepprg
nnoremap <leader>gg :grep!<space>
nnoremap <leader>wg :grep! <cword> .<cr>
nnoremap <leader>Wg :grep! '\b<cword>\b' .<cr>
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
" The thing I hate about this is that it doesn't preserve the last line it was
" on, so I often have to scroll back down. Vinegar does this. TODO look at
" vinegar's code for this since that's the only thing I really use in vinegar
" that I can't get with netrw config.
" nnoremap - :Ex<cr>

" open current file in browser (useful for markdown preview)
function! PreviewInBrowser() abort
    silent !open -a "Google Chrome" %:p
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
" }}}

" Visuals {{{
set redrawtime=10000 " avoid problem with losting syntax highlighting https://github.com/vim/vim/issues/2790#issuecomment-400547834
set background=dark
" set cursorline " highlight current line. this is really slow!
set colorcolumn=80,120 " show vert lines at the psr-2 suggested column limits
" silent! colorscheme lucius " set the default color scheme
if (isdirectory(expand('~/.vim/plugged/vim-hybrid-material')))
    silent! colorscheme hybrid_material
endif
let g:airline_theme = 'base16_ocean'
" let g:netrw_liststyle=3 " use netrw tree view by default (might cause this https://github.com/tpope/vim-vinegar/issues/13)
" set listchars=tab:▸•,eol:¬,trail:•,extends:»,precedes:«,nbsp:¬ " prettier hidden chars. turn on with :set list
set listchars=tab:▸•,trail:•,extends:»,precedes:« " prettier hidden chars. turn on with :set list (without line ending symbols)
augroup isbashgroup
    autocmd!
    autocmd BufRead,BufNewFile *bash* let b:is_bash=1 " fix syntax highlighting for bash files
augroup END

" do not conceal quotes and stuff on the current line! Why would I even want
" that?? It's worse than no formatting if I can't even see the quotes.
augroup jsonformat
    autocmd!
    autocmd FileType json set concealcursor-=n
augroup END

" https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
augroup italic_comments_group
    autocmd!
    autocmd FileType * hi! Comment cterm=italic
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

" }}}

" Plugin Configuration {{{
runtime .vimrc.pluginconfig.vim
" }}}
