" Modeline and Notes {{{
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker filetype=vim:
"
"  ___  ____ _         ______           _
"  |  \/  (_) |        |  ___|         | |
"  | .  . |_| | _____  | |_ _   _ _ __ | | __
"  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
"  | |  | | |   <  __/ | | | |_| | | | |   <
"  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
"
" vimrc, finally free of spf13-vim!
" more info at http://mikefunk.com
" }}}

" Use plugins config {{{
if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
    syntax enable
    filetype plugin on
    " needed for tagbar plugin of vim-airline
    filetype plugin indent on
endif
" }}}

" Functions {{{

" adjust window height between min and max {{{
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}}

" Initialize directories {{{
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

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

" Open php class extension in vertical split {{{
" not working yet :/
command! Opc :normal! mzgg]]$ :vsp<CR>:exec("tag ".expand("<cword>"))<CR>
" }}}

" delete inactive buffers (the ones not in tabs or windows) {{{
" @link http://stackoverflow.com/a/7321131/557215
function! DeleteInactiveBufs()
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

" Strip whitespace {{{
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespace silent! :call StripTrailingWhitespace()<cr>
" }}}

" }}}

" Basics {{{
set hlsearch " Highlight search terms
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
set laststatus=2 " always show a statusline. This fixes airline split issue.
let g:mapleader = ',' " use comma for leader

" NOTE: gn will highlight or visually select the last highlighted search result

" set quickfix window height min and max automatically
augroup quickfix_augroup
    autocmd!
augroup END
autocmd quickfix_augroup FileType qf call AdjustWindowHeight(3, 5)

" autoclose preview window when no longer needed
" autocmd CompleteDone * pclose

" send more characters for redraws
" set ttyfast
" broken in neovim
" set ttymouse=sgr " allow mouse to work after 233 columns

set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

set ignorecase " Case insensitive search
set smartcase " Case sensitive when uc present
set number " turn on line numbering

set iskeyword-=. " '.' is an end of word designator
set iskeyword-=# " '#' is an end of word designator
set iskeyword-=- " '-' is an end of word designator

if has("mouse")
    set mouse=a " Automatically enable mouse usage
    set mousehide " Hide the mouse cursor while typing
endif
set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set foldlevelstart=20 " start by opening pretty much all folds but keep foldenable on.
set history=1000 " Store a ton of history (default is 20)

set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor

" set noswapfile " pesky .swp files
" set nobackup

" php open folds when starting up
au Filetype php au! BufEnter normal zR

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Remove trailing whitespaces and ^M chars
" Unfortunately I have to turn this off because factory class templates have
" whitespace for now.
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,html.twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()

" }}}

" Miscellaneous {{{

" omnicomplete {{{

" Enable omni completion for various languages.
augroup omnifunc_augroup
    autocmd!
augroup END

" autocmd omnifunc_augroup FileType css setlocal omnifunc=csscomplete#CompleteCSS
" this is the csscomplete version
autocmd omnifunc_augroup FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd omnifunc_augroup FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd omnifunc_augroup FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd omnifunc_augroup FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd omnifunc_augroup FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd omnifunc_augroup FileType ruby setlocal omnifunc=rubycomplete#Complete
" }}}

" if the last window is a quickfix, close it {{{
" au WinEnter * au! if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix'|q|endif
augroup qfclose_augroup
    autocmd!
    autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END
" }}}

" fix split dragging in tmux {{{
if &term =~ '^screen' || &term =~ '^xterm' || &term =~ '^st'
    set ttymouse=xterm2
endif
" }}}

" undo {{{
if has('persistent_undo')
    set undofile " persistent undo
    set undolevels=1000 " Maximum number of changes that can be undone
    set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
endif
" }}}

" use register that works with mac clipboard {{{
if has('clipboard')
    if has('unnamedplus') && !has('nvim')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
" }}}

" }}}

" Style {{{
set background=dark
set cursorline
set colorcolumn=80,120

" 256-friendly colors
silent! colorscheme lucius
" silent! colorscheme molokai
" silent! LuciusDarkHighContrast
" silent! colorscheme seoul256
" silent! colorscheme molokayo
" silent! colorscheme badwolf

" gui colors
" silent! colorscheme gotham
" silent! colorscheme Tomorrow-Night-Blue

" @link https://github.com/neovim/neovim/issues/2334
if (has('nvim'))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
" }}}

" Mappings {{{

command! FormatJSON %!python -m json.tool
" (for some reason this mapping is not applying but the command works)
" format json in current file
nnoremap <leader>fj :FormatJSON<cr>

" go to end of use statements in php {{{
" `m to go back
command! GoToUseBlock execute "normal! mmgg/use\ <cr>}:nohlsearch<cr>"
" go the the use block at the top of the php file
nnoremap <leader>gu :GoToUseBlock<cr>
" }}}

" go to last active tab {{{
let g:lasttab = 1
" switch to the last active tab
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
" switch to the last active tab
nnoremap <Leader>lt :exe "tabn ".g:lasttab<CR>
augroup LastTab
    autocmd!
augroup END
autocmd LastTab TabLeave * let g:lasttab = tabpagenr()
" }}}


" since , replaces leader, use \ to go back in a [f]ind
noremap \ ,

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Easier horizontal scrolling
map zl zL
map zh zH

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" vertical and horizontal splits like tmux
nnoremap <c-w>" :sp<cr>
nnoremap <c-w>% :vsp<cr>

" my version of fast tabs
nnoremap gh gT
nnoremap gl gt

" go to url is gx

" use jj for exiting insert mode
inoremap jj <esc>

" vertical and horizontal splits like tmux
nnoremap <c-w>" :sp<cr>
nnoremap <c-w>% :vsp<cr>

" increment with c-b since I use c-a for tmux
nnoremap <c-b> <c-a>
vnoremap <c-b> <c-a>

" resize splits, consistent with tmux bindings {{{
nnoremap <c-w><c-j> :resize +10<cr>
nnoremap <c-w><c-k> :resize -10<cr>
nnoremap <c-w><c-l> :vertical resize +10<cr>
nnoremap <c-w><c-h> :vertical resize -10<cr>
" }}}

" put cursor at end of text on y and p {{{
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
" }}}

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" format all
nnoremap <leader>fa mzggVG=`z :delmarks z<cr>hh :echo "formatted file"<cr>

command! SortUse execute "normal! msgg/use\ <cr>vip:sort<cr>\`s:delmarks s<cr>:nohlsearch<cr>:echo 'sorted use statements'<cr>"
" sort php use statements and return to where you were
nnoremap <leader>su :SortUse<cr>

" when copying php interface methods over, this turns interface stubs into
" empty php methods. e.g. turns
" public function myMethod($whatever);
" into
" public function myMethod($whatever)
" {
"     //
" }
command! ExpandInterfaceMethods :%s/\v(\w+\sfunction\s\w+\(.*\));/\1\r    {\r        \/\/\r    }/g
" Expand all pasted interface methods to a function block
nnoremap <leader>ei :ExpandInterfaceMethods<cr>

" map space to toggle folds
nnoremap <space> za
vnoremap <space> zf

" toggle background
nnoremap <leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>

" dotfile updates and private stuff updates {{{
if isdirectory(expand("~/.vim/plugged/vim-dispatch"))
    if has("nvim")
        command! Dotupdates :tabe | :term! cd $HOME/.dotfiles && git add -A && git commit -am 'updates' && git pull && git push &&cd -
        command! Privateupdates :tabe | :term! cd $HOME/.private-stuff && git add -A && git commit -am 'updates' && git pull && git push &&cd -
    else
        command! Dotupdates :Dispatch cd $HOME/.dotfiles && git add -A && git commit -am 'updates' && git pull && git push &&cd -
        command! Privateupdates :Dispatch cd $HOME/.private-stuff && git add -A && git commit -am 'updates' && git pull && git push &&cd -
    endif
    " add all dotfiles changes, commit, pull and push with vim-dispatch
    nnoremap <leader>tu :Dotupdates<cr>
    " add all private-stuff changes, commit, pull and push with vim-dispatch
    nnoremap <leader>tv :Privateupdates<cr>
endif
" }}}

" toggle search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" open tag in tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

" open tag in vertical split
nnoremap <silent><Leader>v<C-]> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>

" open vhosts file
command! Vhost tabe /etc/apache2/extra/httpd-vhosts.conf

command! Source :so $MYVIMRC
" source vimrc
nnoremap <leader>so :Source<cr>:IndentLinesReset<cr>

if executable('ag') && (isdirectory(expand("~/.vim/plugged/ag.vim")) || isdirectory(expand("~/.vim/plugged/ag.nvim")))
    " show todos
    nnoremap <leader>td :Ag! todo<CR>
endif

" Code folding options {{{
nnoremap <leader>f0 :set foldlevel=0<CR>
nnoremap <leader>f1 :set foldlevel=1<CR>
nnoremap <leader>f2 :set foldlevel=2<CR>
nnoremap <leader>f3 :set foldlevel=3<CR>
nnoremap <leader>f4 :set foldlevel=4<CR>
nnoremap <leader>f5 :set foldlevel=5<CR>
nnoremap <leader>f6 :set foldlevel=6<CR>
nnoremap <leader>f7 :set foldlevel=7<CR>
nnoremap <leader>f8 :set foldlevel=8<CR>
nnoremap <leader>f9 :set foldlevel=9<CR>
" }}}

" }}}

" Syntax highlighting and file types {{{
    " for those weird filetypes that need some help setting the correct filetype
    au BufRead,BufNewFile gulpfile set filetype=javascript
    au BufRead,BufNewFile Gulpfile set filetype=javascript
    au BufRead,BufNewFile *.html.twig set filetype=html.twig
    au BufRead,BufNewFile Vagrantfile set filetype=ruby
    au BufRead,BufNewFile .env set filetype=dosini
    au BufRead,BufNewFile *.phtml set filetype=phtml
    au BufRead,BufNewFile .vimrc.local,.vimrc.plugins set filetype=vim
    au BufRead,BufNewFile .bash_aliases,.bash_env,.bash_completions,.bash_functions,.bash_paths set filetype=sh
    " au BufRead,BufNewFile config set filetype=sshconfig

    " all front-end 2 space indents
    " this is now handled by ~/.editorconfig
    " au FileType smarty,blade,html,javascript,json,css,twig,html.twig,coffee,yaml,cucumber set et sw=2 ts=2 sts=2
" }}}

" Gui {{{
if has("gui_running")
    set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h11
endif
" }}}

" Plugins {{{

" ag.vim {{{
if isdirectory(expand("~/.vim/plugged/ag.vim"))
    cnoreabbrev ag Ag!
endif
" }}}

" accelerated-smooth-scroll {{{
" only enable c-d and c-u. I don't use c-f and c-b and I want to use c-b
" for incrementing values.
if isdirectory(expand("~/.vim/plugged/accelerated-smooth-scroll"))
    let g:ac_smooth_scroll_no_default_key_mappings = 1
    nmap <silent> <C-d> <Plug>(ac-smooth-scroll-c-d)
    nmap <silent> <C-u> <Plug>(ac-smooth-scroll-c-u)
    xmap <silent> <C-d> <Plug>(ac-smooth-scroll-c-d_v)
    xmap <silent> <C-u> <Plug>(ac-smooth-scroll-c-u_v)
endif
" }}}

" BufOnly.vim {{{
if isdirectory(expand("~/.vim/plugged/BufOnly.vim"))
    " typo fixer
    command! -nargs=? -complete=buffer -bang BUfo
        \ :call BufOnly('<args>', '<bang>')
endif
" }}}

" {{{ ctrlp
if isdirectory(expand("~/.vim/plugged/ctrlp.vim"))
    " ctrlp extensions
    let g:ctrlp_extensions = ['tag']

    " allows backspace on empty prompt to exit ctrlp
    " let g:ctrlp_brief_prompt = 1

    " enable ctrlp-py-matcher
    " let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

    " enable cpsm matcher
    " let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }

    " search through buffers with ctrlp
    nnoremap <leader>pb :CtrlPBuffer<CR>
    " search through most recently used files with ctrlp
    nnoremap <leader>pm :CtrlPMRUFiles<CR>

    " use ag in ctrlp for listing files
    if executable('ag')
        " don't respect gitignore either (-U). I want to search inside vendor too.
        let g:ctrlp_user_command = 'ag -U %s -l --nocolor -g ""'
        " help it find agignore
        " let g:ctrlp_user_command = 'ag -U -p ' + $HOME + '/.agignore %s -l --nocolor -g ""'
    endif

    " ignore some dirs
    let g:ctrlp_custom_ignore = {
      \ 'dir':  'build',
      \ 'file': '*.cache.php',
      \ }
endif
" }}}

" ctrlp-smarttabs {{{
if isdirectory(expand("~/.vim/plugged/ctrlp-smarttabs")) && isdirectory(expand("~/.vim/plugged/ctrlp.vim"))
    let g:ctrlp_extensions = ['smarttabs']
    " search through open tabs with ctrlp
    nnoremap <leader>pt :CtrlPSmartTabs<CR>
endif
" }}}

" editorconfig-vim {{{
if isdirectory(expand("~/.vim/plugged/editorconfig-vim")) && isdirectory(expand("~/.vim/plugged/vim-fugitive"))
    " avoid problems with fugitive
    let g:EditorConfig_exclude_patterns = ['fugitive://.*']
endif
" }}}

" {{{ fugitive
if isdirectory(expand("~/.vim/plugged/vim-fugitive"))
    let g:fugitive_github_domains = ['http://gitlab.prod.dm.local', 'https://git.github.com', 'https://gitlab.las.prod']

    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    " nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>

    " if has("nvim")
        " nnoremap <leader>gps :tabe | :term! git push<CR>
        " nnoremap <leader>gpu :tabe | :term! git push<CR>
        " nnoremap <leader>gpl :tabe | :term! git pull<CR>:e<cr>
    " else
        nnoremap <leader>gps :Dispatch! git push<CR>
        nnoremap <leader>gpu :Dispatch! git push<CR>
        nnoremap <leader>gpl :Dispatch! git pull<CR>:e<cr>
    " endif
    nnoremap <leader>ga :Git add -A<CR><CR>
endif
" }}}"

" {{{ phpcomplete
if isdirectory(expand("~/.vim/plugged/phpcomplete.vim"))
    " phpcomplete omni complete group
    augroup phpcomplete_augroup
        autocmd!
    augroup END

    " only for php set the omnifunc to completephp
    "
    " enable:
    " autocmd phpcomplete_augroup FileType php set omnifunc=phpcomplete#CompletePHP
    "
    " disable (because it's SLOW):
    autocmd phpcomplete_augroup FileType php set omnifunc=

    " this lets non-static methods be called in static context. Good for laravel.
    " let g:phpcomplete_relax_static_constraint = 1
    " composer install command for phpcomplete
    let g:phpcomplete_index_composer_command = "composer"

    " default: 0. show more info in the preview window and return types. Slower.
    let g:phpcomplete_parse_docblock_comments = 1
    " let g:phpcomplete_parse_docblock_comments = 0

    " Enables use of tags when the plugin tries to find variables. When
    " enabled the plugin will search for the variables in the tag files with
    " kind 'v', lines like $some_var = new Foo; but these usually yield highly
    " inaccurate results and can be fairly slow.
    " default: 0
    " let g:phpcomplete_search_tags_for_variables = 1

    " default: 1.
    " this avoids an error in php-cs-fixer.vim
    " let g:phpcomplete_enhance_jump_to_definition = 0

    " default: 1.
    " let g:phpcomplete_cache_taglists = 1

    " adds additional built-in functions from php to the completable ones
    " available extensions: https://github.com/shawncplus/phpcomplete.vim/blob/master/misc/available_extensions
    let g:phpcomplete_add_function_extensions = [
    \ 'arrays',
    \ 'strings',
    \ 'urls',
    \ 'filesystem',
    \ 'curl',
    \ 'json',
    \ 'mail',
    \ 'misc',
    \ 'sessions',
    \ ]
    " \ 'mysql',
    " \ 'mysqli',

    " same for interfaces
    let g:phpcomplete_add_interface_extensions = [
    \ 'predefined_interfaces_and_classes',
    \ ]

    " don't try to complete this crap
    let g:phpcomplete_remove_function_extensions = ['xslt_php_4']
    let g:phpcomplete_remove_constant_extensions = ['xslt_php_4']
    " complete these built-in functions, classes, etc.
    " let g:phpcomplete_add_function_extensions = [...]
    " let g:phpcomplete_add_class_extensions = [...]
    " let g:phpcomplete_add_interface_extensions = [...]
    " let g:phpcomplete_add_constant_extensions = [...]
endif
" }}}"

" NERDCommenter {{{
if isdirectory(expand("~/.vim/plugged/nerdcommenter"))
    " extra space in NERDCommenter comments
    let g:NERDSpaceDelims="1"
    " custom delimiters for scss and stuff
    let g:NERDCustomDelimiters = {
        \ 'scss': { 'left': '//' },
    \ }
endif
" }}}

" NERDTree {{{
if isdirectory(expand("~/.vim/plugged/nerdtree"))
    nnoremap <C-e> :NERDTreeMirrorToggle<CR>
    " open nerdtree at the current document
    nnoremap <leader>nt :NERDTreeFind<CR>
    let NERDTreeShowHidden=1
    let NERDTreeMouseMode=2
    let NERDTreeQuitOnOpen=1
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '\.DS_Store$']
    let g:nerdtree_tabs_open_on_gui_startup=0
endif
" }}}

" padawan.vim {{{
if isdirectory(expand("~/.vim/plugged/padawan.vim")) && isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
    let g:ycm_semantic_triggers = {}
    let g:ycm_semantic_triggers.php = ['->', '::', '(', 'use ', 'namespace ', '\']
    let g:padawan#composer_command = "composer"
endif
" }}}

" {{{ PDV
" (php documentor for vim)
if isdirectory(expand("~/.vim/plugged/pdv"))
    let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
    " document the current element with php documentor for vim
    nnoremap <leader>pd :call pdv#DocumentWithSnip()<CR>
endif
" }}}

" {{{ phpctags
if isdirectory(expand("~/.vim/plugged/tagbar-phpctags.vim"))
    " phpctags
    let g:tagbar_phpctags_memory_limit = '512M'
endif
" }}}"

" php-documentor-vim {{{
if isdirectory(expand("~/.vim/plugged/php-documentor-vim"))
    " @link https://github.com/sumpygump/php-documentor-vim
    au BufRead,BufNewFile *.php inoremap <buffer> <leader>pd :call PhpDoc()<CR>
    au BufRead,BufNewFile *.php nnoremap <buffer> <leader>pd :call PhpDoc()<CR>
    au BufRead,BufNewFile *.php vnoremap <buffer> <leader>pd :call PhpDocRange()<CR>
endif
" }}}

" {{{ promptline
if isdirectory(expand("~/.vim/plugged/promptline.vim"))
    " use airline extensions for promptline
    " let g:airline#extensions#promptline#enabled = 1
    let g:airline#extensions#promptline#enabled = 0
    let g:airline#extensions#promptline#snapshot_file = "~/.dotfiles/to_link/promptline.theme.bash"
    " let airline#extensions#promptline#color_template = 'normal'
    " let airline#extensions#promptline#color_template = 'insert'
    " let airline#extensions#promptline#color_template = 'visual'
    " let airline#extensions#promptline#color_template = 'replace'

    " easily save a snapshot of my current setup to my promptline file
    command! MyPromptline :PromptlineSnapshot! ~/.dotfiles/to_link/promptline.theme.bash

    " let g:promptline_theme = 'powerlineclone'
    " let g:promptline_theme = 'airline'
    let g:promptline_theme = 'airline_insert'
    " let g:promptline_theme = 'airline_visual'
    let g:promptline_preset = 'full'
endif
" }}}"

" sessionman.vim {{{
if isdirectory(expand("~/.vim/plugged/sessionman.vim/"))
    nnoremap <Leader>sl :SessionList<CR>
    nnoremap <Leader>ss :SessionSave<CR>
    nnoremap <Leader>sc :SessionClose<CR>
endif
" }}}

" Syntastic {{{
if isdirectory(expand("~/.vim/plugged/syntastic"))
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['html'] }
    " if executable('jsxhint')
        " let g:javascript_checkers = ['jsxhint']
    " endif
    if executable('eslint')
        " let g:syntastic_javascript_checkers = ['eslint', 'jscs']
        let g:syntastic_javascript_checkers = ['eslint']
    endif

    " recommended settings from their docs
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    " let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0

    " spiffy error columns
    " causing problems with spacing
    " let g:syntastic_enable_signs = 1
    " let g:syntastic_error_symbol='✗'
    " let g:syntastic_warning_symbol='⚠'
    " let g:syntastic_style_error_symbol='✗'
    " let g:syntastic_style_warning_symbol='⚠'
endif
" }}}

" {{{ tagbar
if isdirectory(expand("~/.vim/plugged/tagbar"))
    " tagbar autofocus is the whole point of tagbar
    let g:tagbar_autofocus = 1
    let g:tagbar_autoclose = 1
    nnoremap <silent> <leader>tt :TagbarToggle<CR>

    " css support
    let g:tagbar_type_css = {
    \ 'ctagstype' : 'Css',
        \ 'kinds'     : [
            \ 'c:classes',
            \ 's:selectors',
            \ 'i:identities'
        \ ]
    \ }

    " ultisnips support
    " let g:tagbar_type_snippets = {
        " \ 'ctagstype' : 'snippets',
        " \ 'kinds' : [
            " \ 's:snippets',
        " \ ]
    " \ }
endif
" }}}

" {{{ tmuxline
if executable('tmux') && isdirectory(expand("~/.vim/plugged/tmuxline.vim"))
    command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.dotfiles/support/tmuxline.conf

    " use airline theme stuff when calling tmuxline
    " let g:airline#extensions#tmuxline#enabled = 1
    let g:airline#extensions#tmuxline#enabled = 0
    " let airline#extensions#tmuxline#color_template = 'insert'
    " let airline#extensions#tmuxline#color_template = 'visual'
    " let airline#extensions#tmuxline#color_template = 'replace'

    " let g:tmuxline_theme = 'airline'
    " let g:tmuxline_theme = 'airline_insert'
    " let g:tmuxline_theme = 'airline_visual'
    " let g:tmuxline_theme = 'iceberg'
    " let g:tmuxline_theme = 'jellybeans'
    " let g:tmuxline_theme = 'lightline'
    " let g:tmuxline_theme = 'lightline_insert'
    " let g:tmuxline_theme = 'lightline_visual'
    " let g:tmuxline_theme = 'nightly_fox'
    " let g:tmuxline_theme = 'powerline'
    " let g:tmuxline_theme = 'vim_powerline'
    " let g:tmuxline_theme = 'vim_statusline_1'
    " let g:tmuxline_theme = 'vim_statusline_2'
    let g:tmuxline_theme = 'vim_statusline_3'
    " let g:tmuxline_theme = 'zenburn'

    " let g:tmuxline_preset = 'full'
    " let g:tmuxline_preset = 'powerline'
    let g:tmuxline_preset = {
        \ 'a'    : ['❏ #S'],
        \ 'b'    : ['#H'],
        \ 'win'  : ['#I', '#W'],
        \ 'cwin' : ['#I', '#W#F'],
        \ 'x'    : ['#(battery -t)'],
        \ 'z'    : ['%a', '%b %d', '%I:%M %p'],
    \}
    let g:airline#extensions#tmuxline#snapshot_file = "~/.dotfiles/support/tmuxline.conf"
endif
" }}}

" {{{ ultisnips
if isdirectory(expand("~/.vim/plugged/ultisnips"))
    let g:snips_author = 'Michael Funk <mike.funk@demandmedia.com>'
    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsListSnippets='<c-l>'

    " Fix for neovim
    " let g:UltiSnipsUsePythonVersion = 2

    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = '<C-j>'
    " let g:UltiSnipsExpandTrigger = '<C-Enter>'
    " let g:UltiSnipsExpandTrigger = '<Tab>'
    let g:UltiSnipsJumpForwardTrigger = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
    " let g:UltiSnipsJumpForwardTrigger = '<C-f>'
    " let g:UltiSnipsJumpBackwardTrigger = '<C-b>'
endif
" }}}"

" {{{ undoclosewin
if isdirectory(expand("~/.vim/plugged/undoclosewin.vim"))
    " undo close window - really it's undo close tab
    nnoremap <leader>uc :UcwRestoreWindow<cr>
endif
" }}}

" {{{ undotree
if isdirectory(expand("~/.vim/plugged/undotree"))
    silent! unmap <leader>u
    " toggle undotree window
    nnoremap <leader>uu :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
endif
" }}}

" {{{ vdebug xdebug plugin
if isdirectory(expand("~/.vim/plugged/vdebug"))
    "
    " default options:
    "
    " \    "port" : 9000,
    " \    "server" : '',
    " \    "timeout" : 20,
    " \    "on_close" : 'detach',
    " \    "break_on_open" : 1,
    " \    "ide_key" : '',
    " \    "path_maps" : {},
    " \    "debug_window_level" : 0,
    " \    "debug_file_level" : 0,
    " \    "debug_file" : "",
    " \    "watch_window_style" : 'expanded',
    " \    "marker_default" : '⬦',
    " \    "marker_closed_tree" : '▸',
    " \    "marker_open_tree" : '▾'
    "
    let g:vdebug_options = {}

    " this port is strangely used as the nginx pool port. It's also the xdebug
    " default.
    " let g:vdebug_options['port'] = 9000

    " local machine php
    " let g:vdebug_options['port'] = 9001
    " zed VM
    " let g:vdebug_options['port'] = 9015
    " saatchi VM
    let g:vdebug_options['port'] = 9010

    " This is if you want to limit to only connecting to a specific server.
    " Leave empty for any server.
    " let g:vdebug_options['server'] = '127.0.0.1'
    let g:vdebug_options['server'] = ''
    let g:vdebug_options['timeout'] = 30
    let g:vdebug_options['on_close'] = 'detach'
    " default: 1. stop on first line of execution
    let g:vdebug_options["break_on_open"] = 1
    " let g:vdebug_options["break_on_open"] = 0
    let g:vdebug_options['ide_key'] = 'mikedfunkxd'
    " can add multiple path maps to this array, just duplicate the line
    " below and add another. remote is first, local is second.
    let g:vdebug_options['path_maps'] = {
    \   '/data/code_base/current': '/Library/WebServer/Documents/saatchi/saatchiart',
    \   '/data/shop/current': '/Library/WebServer/Documents/saatchi/yzed'
    \}
    let g:vdebug_options['debug_window_level'] = 0
    let g:vdebug_options['debug_file_level'] = 0
    let g:vdebug_options['debug_file'] = ''
    let g:vdebug_options['watch_window_style'] = 'compact'
    let g:vdebug_options['marker_default'] = '⬦'
    let g:vdebug_options['marker_closed_tree'] = '▸'
    let g:vdebug_options['marker_open_tree'] = '▾'
    " let g:vdebug_options['continuous_mode'] = 1
    let g:vdebug_options['continuous_mode'] = 0
    " move run_to_cursor from F1 to F9
    let g:vdebug_keymap = {
    \    "step_over" : "<F2>",
    \    "step_into" : "<F3>",
    \    "step_out" : "<F4>",
    \    "run" : "<F5>",
    \    "close" : "<F6>",
    \    "detach" : "<F7>",
    \    "run_to_cursor" : "<F9>",
    \    "set_breakpoint" : "<F10>",
    \    "get_context" : "<F11>",
    \    "eval_under_cursor" : "<F12>",
    \    "eval_visual" : "<Leader>ev",
    \}
endif
" }}}

" {{{ vim-airline
if isdirectory(expand("~/.vim/plugged/vim-airline"))

    " airline use cool powerline symbols
    let g:airline_powerline_fonts=1

    " when gutentags is updating show in the statusbar
    " if isdirectory(expand("~/.vim/plugged/vim-gutentags"))
        " augroup gutentags_augroup
            " autocmd!
        " augroup END
        " need to add this as a new segment. section_x is already used for
        " tagbar integration in php.
        " autocmd gutentags_augroup FileType php let g:airline_section_x = '%{gutentags#statusline("Updating Tags... ")}%{airline#util#wrap(airline#parts#filetype(),0)}'
    " endif

    let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
    " spiffy git symbols
    " let g:airline#extensions#hunks#hunk_symbols = ['✚', '✎', '✖']

    if (isdirectory(expand("~/.vim/plugged/tagbar")))
        augroup php_tagbar
            autocmd!
        augroup END
        " warning php tagbar is really slow. So I only enabled it for php files.
        if (isdirectory(expand("~/.vim/plugged/vim-airline")))
            autocmd php_tagbar FileType php let g:airline#extensions#tagbar#enabled = 1
            " let g:airline#extensions#tagbar#enabled=1
        endif
        " change how tags are displayed (:help tagbar-statusline)
          " let g:airline#extensions#tagbar#flags = '' " (default)
          " let g:airline#extensions#tagbar#flags = 'f'
          " let g:airline#extensions#tagbar#flags = 's'
          " let g:airline#extensions#tagbar#flags = 'p'
    endif

    " advanced tabline
    let g:airline#extensions#tabline#enabled = 1

    " configure symbol used to represent close button
    let g:airline#extensions#tabline#close_symbol = '✕'

    " only show non-zero hunk changes
    let g:airline#extensions#hunks#non_zero_only = 1

    " configure how numbers are displayed in tab mode. >
    " let g:airline#extensions#tabline#tab_nr_type = 0 " # of splits (default)
    let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
    " let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number

    " change feature/whatever to whatever
    let g:airline#extensions#branch#format = 1

    " When enabled, numbers will be displayed in the tabline and mappings will be
    " exposed to allow you to select a buffer directly.  Up to 9 mappings will be
    " exposed.
    " let g:airline#extensions#tabline#buffer_idx_mode = 1
    " I don't think it automatically sets these mappings
    " nmap <leader>1 <Plug>AirlineSelectTab1
    " nmap <leader>2 <Plug>AirlineSelectTab2
    " nmap <leader>3 <Plug>AirlineSelectTab3
    " nmap <leader>4 <Plug>AirlineSelectTab4
    " nmap <leader>5 <Plug>AirlineSelectTab5
    " nmap <leader>6 <Plug>AirlineSelectTab6
    " nmap <leader>7 <Plug>AirlineSelectTab7
    " nmap <leader>8 <Plug>AirlineSelectTab8
    " nmap <leader>9 <Plug>AirlineSelectTab9
endif

" }}}

" vim-gutentags {{{
if isdirectory(expand("~/.vim/plugged/vim-gutentags"))

    " these are supposed to speed up ctags
    set tags=tags
    set path=.

    " let g:gutentags_exclude = []
    let g:gutentags_exclude = [
        \ '.git',
        \ '*.log',
        \ '*.min.js',
        \ '*.coffee',
        \ 'bootstrap.php.cache',
        \ 'classes.php.cache',
        \ 'app/cache',
        \ '__TwigTemplate_*'
    \]
    " to use cscope instead of ctags: (Didn't work for me)
    " let g:gutentags_modules = [ 'cscope' ]
endif
" }}}

" {{{ vim-indentline
if isdirectory(expand("~/.vim/plugged/indentLine"))
    " let g:indentLine_leadingSpaceEnabled = 1
    let g:indentLine_char = '┆'
endif
" }}}

" vim-json {{{
if isdirectory(expand("~/.vim/plugged/vim-json"))
    " turn off stupid no quotes in JSON except for current line
    let g:vim_json_syntax_conceal = 0
    " uh oh, it doesn't work well with indentLine plugin...
    " https://github.com/elzr/vim-json/issues/23#issuecomment-40293049
    let g:indentLine_noConcealCursor = ""
endif
" }}}

" vim-mark {{{
if isdirectory(expand("~/.vim/plugged/vim-mark"))
    let g:mark_no_mappings = 1
endif
" }}}

" vim-move {{{
if isdirectory(expand("~/.vim/plugged/vim-move"))
    let g:move_key_modifier = 'C'
endif
" }}}

" vim-notes {{{
if isdirectory(expand("~/.vim/plugged/vim-notes"))
    let g:notes_directories = ['~/notes']
    " Map ,ns in visual mode to start new note with selected text as title.
endif
" }}}

" vim-php-cs-fixer {{{
if isdirectory(expand("~/.vim/plugged/vim-php-cs-fixer"))
    " just do psr-2. I don't want all your opinionated stuff.
    let g:php_cs_fixer_level = "psr2"
endif
" }}}

" vim-php-manual {{{
if isdirectory(expand("~/.vim/plugged/vim-php-manual"))
    vnoremap <silent> <buffer> <S-K> y:call phpmanual#online#open(@@)<CR>
    nnoremap <silent> <buffer> <S-K> :call phpmanual#online#open()<CR>
endif
" }}}

" {{{ vim-php-namespace
if isdirectory(expand("~/.vim/plugged/vim-php-namespace"))
    " php add use statement for current class
    inoremap <Leader><Leader>u <C-O>:call PhpInsertUse()<CR>
    " php add use statement for current class
    noremap <Leader><Leader>u :call PhpInsertUse()<CR>
    " expand the namespace for the current class name
    inoremap <Leader><Leader>e <C-O>:call PhpExpandClass()<CR>
    " expand the namespace for the current class name
    noremap  <Leader><Leader>e :call PhpExpandClass()<CR>
endif
" }}}

" vim-php-refactoring {{{
if isdirectory(expand("~/.vim/plugged/vim-php-refactoring")) && executable("refactor")
    let g:php_refactor_command='refactor'
endif
" }}}

" vim-php-refactoring-toolbox {{{
if isdirectory(expand("~/.vim/plugged/vim-php-refactoring-toolbox"))
    let g:vim_php_refactoring_auto_validate_visibility=0
endif
" }}}

" vim-plug {{{
if filereadable(expand("~/.vim/autoload/plug.vim"))
    " Install any newly added plugins in ~/.vimrc.plugins
    nnoremap <leader>bi :so ~/.vimrc.plugins<cr> :PlugInstall<cr>
    " Remove any newly removed plugins in ~/.vimrc.plugins
    nnoremap <leader>bc :so ~/.vimrc.plugins<cr> :PlugClean!<cr>
    " Upgrade all installed plugins in ~/.vimrc.plugins
    nnoremap <leader>bu :so ~/.vimrc.plugins<cr> :PlugUpgrade<cr> :PlugUpdate<cr> :UpdateRemotePlugins<cr>
endif
" }}}

" vim-speeddating {{{
if isdirectory(expand("~/.vim/plugged/vim-speeddating"))
    let g:speeddating_no_mappings = 1
    " use c-b instead
    nmap  <C-B>     <Plug>SpeedDatingUp
    nmap  <C-X>     <Plug>SpeedDatingDown
    xmap  <C-B>     <Plug>SpeedDatingUp
    xmap  <C-X>     <Plug>SpeedDatingDown
    nmap d<C-B>     <Plug>SpeedDatingNowUTC
    nmap d<C-X>     <Plug>SpeedDatingNowLocal
endif
" }}}

" vim-signify {{{
if isdirectory(expand("~/.vim/plugged/vim-signify"))
    " I rarely use hg
    " let g:signify_vcs_list = [ 'git', 'hg' ]
    let g:signify_vcs_list = [ 'git' ]
endif
" }}}

" {{{ vim-startify
if isdirectory(expand("~/.vim/plugged/vim-startify"))
    if (has('nvim'))
        let g:startify_custom_header = [
            \ '                             _         ',
            \ '      ____  ___  ____ _   __(_)___ ___ ',
            \ '     / __ \/ _ \/ __ \ | / / / __ `__ \',
            \ '    / / / /  __/ /_/ / |/ / / / / / / /',
            \ '   /_/ /_/\___/\____/|___/_/_/ /_/ /_/ ',
            \ '   ',
            \ '   ',
            \ ]
    else
        let g:startify_custom_header = [
            \ '                                 ________  __ __        ',
            \ '            __                  /\_____  \/\ \\ \       ',
            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
            \ '',
            \ '',
            \ ]
    endif

    let g:startify_session_dir = '~/.vim/sessions'
    " a list if files to always bookmark. Will be shown at bottom
    " of the startify screen.
    let g:startify_bookmarks = [ '~/.vimrc', '~/.vimrc.plugins' ]
    " always cd to git root on startup
    let g:startify_change_to_vcs_root = 1

    " disable common but unimportant files
    let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ '\.DS_Store'
        \ ]

    " make vim startify show recent files
    " set viminfo='100,n$HOME/.vim/files/info/viminfo

    " autoload Session.vim in the current dir
    let g:startify_session_autoload = 1

    " auto save session on exit like obsession
    let g:startify_session_persistence = 1

    " startify in new tabs
    " disabled because it messes up opening legit files in new tabs
    " if has('nvim')
        " au! TabNewEntered * Startify
    " endif
endif
" }}}"

" {{{ vim-togglelist
if isdirectory(expand("~/.vim/plugged/vim-togglelist"))
    nnoremap <script> <silent> <leader>ll :call ToggleLocationList()<CR>
    nnoremap <script> <silent> <leader>qq :call ToggleQuickfixList()<CR>
endif
" }}}

" {{{ vim-autoclose
if isdirectory(expand("~/.vim/plugged/vim-autoclose"))
    " don't put closing "s in vimscript files
    let g:autoclose_vim_commentmode = 1
endif
" }}}
"
" VimCompletesMe {{{
if isdirectory(expand("~/.vim/plugged/VimCompletesMe"))
    " reverse direction of tab and shift-tab
    " let g:vcm_direction = 'p'
    augroup vimcompletesme_augroup
        autocmd!
    augroup END
    autocmd vimcompletesme_augroup InsertLeave * if pumvisible() == 0|pclose|endif
    autocmd vimcompletesme_augroup FileType php let b:vcm_tab_complete = "omni"
endif
" }}}

" {{{ vimux
if isdirectory(expand("~/.vim/plugged/vimux")) && executable('tmux')
    let g:VimuxHeight = "40"
    nnoremap <leader>vp :VimuxPromptCommand<cr>
    " open vimux window at the current directory and focus it
    nnoremap <leader>vc :VimuxPromptCommand<cr>cd $PWD<cr>:VimuxInspectRunner<cr>
    nnoremap <leader>vl :VimuxRunLastCommand<cr>
    nnoremap <leader>vv :VimuxRunLastCommand<cr>
    nnoremap <leader>vr :VimuxRunLastCommand<cr>
    nnoremap <leader>vi :VimuxInspectRunner<cr>
    nnoremap <leader>vx :VimuxCloseRunner<cr>
    nnoremap <leader>vz :VimuxZoomRunner<cr>

    "nnoremap <leader>pf :VimuxPHPUnitRunCurrentFile<cr>
    "nnoremap <leader>pu :call VimuxRunCommand("phpunit")<cr>
    "nnoremap <leader>pp :VimuxRunLastCommand<cr>
endif
" }}}

" {{{ youcompleteme
if isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
    " enable completion from tags
    let g:ycm_collect_identifiers_from_tags_files = 1

    " supposed to speed up ycm
    let g:ycm_register_as_syntastic_checker = 0

    " open preview window while completing
    let g:ycm_add_preview_to_completeopt = 1
    " this is cool but I want it to stay open while I'm entering method params
    " so I know what they are
    " let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_autoclose_preview_window_after_insertion = 1

    " disable youcompleteme
    " let g:ycm_auto_trigger=0

    " let g:ycm_allow_changing_updatetime=0
    let g:ycm_seed_identifiers_with_syntax = 1

    " add some triggers
    let g:ycm_semantic_triggers = {}
    let g:ycm_semantic_triggers.php = ['->', '::', '(', 'use ', 'namespace ', '\']
endif
" }}}

" {{{ ZoomWin
if isdirectory(expand("~/.vim/plugged/ZoomWin"))
    " mapping just like <c-a>z for tmux
    nnoremap <c-w>z :ZoomWin<cr>
endif
" }}}

" }}}
