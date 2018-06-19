" vim: set foldmethod=marker ft=vim:
" configuration for plugins I use
scriptencoding utf-8

" accelerated-smooth-scroll {{{
let g:ac_smooth_scroll_min_limit_msec = 80 " confusiong option to speed up scrolling with slow rendering. default is 50.
" }}}

" ale {{{
" NOTE: not working with rubocop for some reason. Fails silently

" https://github.com/w0rp/ale/issues/1176#issuecomment-348149374
" I have added an option for caching failing executable checks. Use let
" g:ale_cache_executable_check_failures = 1 in vimrc, and failing executable
" checks will be cached, along with successful ones.
" This behaviour is off by default, because it means you have to restart Vim
" to run linters after you install them.
let g:ale_cache_executable_check_failures = 1

" syntastic-style - lint on save only
" Active mode - turn these off in .vimrc if it's too slow (use manual maps instead)
let g:ale_lint_on_save = 1 " acceptable speed
" let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'

let g:ale_fix_on_save = 1 " This is off by default. You could do it manually with :ALEFix

let g:ale_sign_column_always = 1 " otherwise screen keeps jumping left and right
let g:airline#extensions#ale#error_symbol = 'Errors:' " default is a bit sparse: E
let g:airline#extensions#ale#warning_symbol = 'Warnings:' " default is W

if isdirectory(expand('~/.vim/plugged/ale'))
    nmap <silent> [w <Plug>(ale_previous_wrap)
    nmap <silent> ]w <Plug>(ale_next_wrap)
    nnoremap <leader>al :ALELint<cr>
    nnoremap <leader>af :ALEFix<cr>
endif

" Set up fixers and linters
" defining linters and fixers is only required if you want to use only a
" subset of available linters or fixers. Otherwise it uses all available
" linters or fixers in separate processes asynchronously.
let s:js_linters = []
let s:js_fixers = ['importjs']
let s:php_linters = ['php']
let s:php_fixers = []

if executable('./node_modules/.bin/flow') | call add(s:js_linters, 'flow') | endif
if executable('./node_modules/.bin/eslint') | call add(s:js_linters, 'eslint') | endif

if filereadable('phpcs.xml')
    let g:ale_php_phpcs_standard = getcwd() . '/phpcs.xml'
    let g:ale_php_phpcbf_standard = getcwd() . '/phpcs.xml'
    call add(s:php_linters, 'phpcs')
    call add(s:php_fixers, 'phpcbf')
endif

if (filereadable('.php_cs'))
    let g:ale_php_cs_fixer_options = '--config=.php_cs'
    call add(s:php_fixers, 'php_cs_fixer')
endif

" really I don't need to lint phpmd on every save :/
" if filereadable('phpmd.xml')
"     let g:ale_php_phpmd_ruleset = getcwd() . ('/phpmd.xml')
"     call add(s:php_linters, 'phpmd')
" endif
if (filereadable('phpstan.neon'))
    let g:ale_php_phpstan_configuration = getcwd() . '/phpstan.neon'
    call add(s:php_linters, 'phpstan')
endif
if executable('./node_modules/.bin/eslint') | call add(s:js_linters, 'eslint') | endif
if executable('./node_modules/.bin/prettier-eslint') | call add(s:js_fixers, 'prettier_eslint') | endif

" If I don't do this, phpcbf fails on any file in the exclude-pattern :/
let g:ale_php_phpcbf_executable = '/Users/mikefunk/.support/phpcbf-helper.sh'
" let g:ale_php_phpcbf_executable = '~/.support/phpcbf-helper.sh'
" in order to get the alternate executable working you have to declare it as
" use global, even though it's not 'global' :/
let g:ale_php_phpcbf_use_global = 1

let g:ale_linters = {
\    'sh': ['shellcheck'],
\    'scss': ['stylelint', 'scsslint'],
\    'json': ['jsonlint'],
\    'javascript': s:js_linters,
\    'php': s:php_linters,
\    'ruby': ['rubocop'],
\    'vim': ['vint']
\ }
let g:ale_fixers = {
\    'scss': ['stylelint'],
\    'javascript': s:js_fixers,
\    'php': s:php_fixers,
\    'ruby': ['rubocop']
\ }
" \    'json': ['jq'],
" \    'sh': ['shfmt'],
" }}}

" asyncrun.vim {{{
if isdirectory(expand('~/.vim/plugged/asyncrun.vim'))
    nnoremap <leader>qq :call asyncrun#quickfix_toggle(8)<cr>
    if isdirectory(expand('~/.vim/plugged/vim-fugitive'))
        " @link https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins#fugitive
        command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
    endif
    " update yadm dotfiles and private files
    command! AllUpdates :AsyncRun
                \ yadm pull -r --autostash &&
                \ yadm add -u && yadm commit -m 'updates';
                \ yadm push;
    nnoremap <leader>ta :AllUpdates<cr>
    nnoremap <leader>gu :AsyncRun git ctags a<cr>
endif
" }}}

" auto-pairs {{{
" let g:AutoPairsFlyMode = 1 " Fly Mode will always force closed-pair jumping instead of inserting. only for ')', '}', ']'
" }}}

" challenger-deep-theme {{{
let g:challenger_deep_termcolors = 16
" }}}

" completor.vim {{{
" enabling this slows down completion. just use c-x c-o when you want omni.
" let g:completor_php_omni_trigger = '([$\w]+|use\s*|->[$\w]*|::[$\w]*|implements\s*|extends\s*|class\s+[$\w]+|new\s*)$'

" }}}

" deoplete.nvim {{{
" let g:deoplete#enable_at_startup = 1
" }}}

" echodoc.vim {{{
let g:echodoc#enable_at_startup = 1
" }}}

" editorconfig-vim {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*'] " work with fugitive. this should be default.
" }}}

" emmet-vim {{{
" html:5<ctrl-y>, for html5 basic layout
" }}}

" fzf.vim {{{
" this was making it ignore .agignore too :/
let $FZF_DEFAULT_COMMAND = 'ag -l --skip-vcs-ignores -g ""'
" let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

if isdirectory(expand('~/.vim/plugged/fzf.vim'))
    " :Ag  - Start fzf with hidden preview window that can be enabled with ? key
    " :Ag! - Start fzf in fullscreen and display the preview window above
    command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
    " Likewise, :Files command with preview window
    command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    nnoremap <leader>ag :Ag<cr>
    nnoremap <leader>ff :Files<cr>
endif
" }}}

" fzf-mru.vim {{{
" only show MRU files from within your cwd
let g:fzf_mru_relative = 1
" }}}

" gist-vim {{{
if isdirectory(expand('~/.vim/plugged/gist-vim'))
    nnoremap <leader>gi :Gist<cr>
endif
" }}}

" gruvbox {{{
let g:gruvbox_italic=1
" }}}

" javascript-libaries-syntax.vim {{{
let g:used_javascript_libs = ''
" let g:used_javascript_libs = 'jquery'
" add these to project vimrcs that need them:
" autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
" autocmd BufReadPre *.js let b:javascript_lib_use_flux = 1
" autocmd BufReadPre *.js let b:javascript_lib_use_vue = 1
" autocmd BufReadPre *.js let b:javascript_lib_use_d3 = 1
" }}}

" language-client-neovim {{{
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'php': ['php', '~/.composer/vendor/bin/php-language-server.php']
\ }
if isdirectory(expand('~/.vim/plugged/LanguageClient-neovim'))
    augroup language_client_neovim_augroup
        autocmd!
        autocmd filetype php set omnifunc=LanguageClient#complete
    augroup END
endif
" }}}

" MatchTagAlways {{{
if isdirectory(expand('~/.vim/plugged/MatchTagAlways'))
    augroup mta_group
        autocmd!
        autocmd FileType phtml,html,html.twig,xml nnoremap <leader>% :MtaJumpToOtherTag<cr>
    augroup END
endif
let g:mta_filetypes = {
            \ 'html' : 1,
            \ 'phtml' : 1,
            \ 'html.twig' : 1,
            \ 'blade' : 1,
            \ 'xml' : 1,
            \ 'javascript.jsx' : 1,
            \}
" }}}

" minimap.vim {{{
let g:minimap_toggle = '<leader>mm'
" }}}

" mucomplete {{{
let g:mucomplete#enable_auto_at_startup = 1
if isdirectory(expand('~/.vim/plugged/vim-mucomplete'))
    set completeopt+=menuone
    set shortmess+=c
    set completeopt+=noinsert,noselect " For automatic completion
endif
" }}}

" nerdcommenter {{{
" extra space in NERDCommenter comments
let g:NERDSpaceDelims='1'
" }}}

" neoformat {{{
" use phpcbf instead of old-ass PHP_Beautifier
let g:neoformat_php_phpcbf = {
    \ 'exe': 'phpcbf',
    \ 'args': [
        \ '--standard=phpcs.xml',
        \ '--extensions=php',
        \ '%',
        \ '||',
        \ 'true'
        \ ],
    \ 'stdin': 1,
    \ 'no_append': 1
    \ }
let g:neoformat_enabled_php = ['phpcbf']
let g:neoformat_enabled_javascript = ['prettiereslint']
let g:neoformat_basic_format_align = 1 " Enable alignment
let g:neoformat_basic_format_retab = 1 " Enable tab to spaces conversion
let g:neoformat_basic_format_trim = 1 " Enable trimmming of trailing whitespace
" let g:neoformat_try_formatprg = 1
" autoformat on save
" augroup neoformat_augroup
"     autocmd!
    " autocmd BufWritePre * Neoformat
    " autocmd BufWritePre * undojoin | Neoformat
" augroup END
" }}}

" onedark.vim {{{
let g:onedark_termcolors=16
" }}}

" padawan.vim {{{
let g:padawan#composer_command = 'composer'
" }}}

" {{{ pdv
" (php documentor for vim)
let g:pdv_template_dir = $HOME .'/.vim/plugged/pdv/templates_snip'
if isdirectory(expand('~/.vim/plugged/pdv'))
    " document the current element with php documentor for vim
    augroup pdvgroup
        autocmd!
        autocmd FileType php nnoremap <leader>pd :call pdv#DocumentWithSnip()<CR>
    augroup END
endif
" }}}

" phpcd {{{
if isdirectory(expand('~/.vim/plugged/deoplete.nvim')) && isdirectory(expand('~/.vim/plugged/phpcd.vim'))
    let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
    let g:deoplete#ignore_sources.php = ['omni']
    " let g:deoplete#ignore_sources.php = ['phpcd', 'omni'] " will disable phpcd from deoplete
endif
" }}}

" php.vim {{{
if isdirectory(expand('~/.vim/plugged/php.vim'))
    " highlight docblocks
    augroup phpdoctagsgroup
        autocmd!
        " docblock color
        autocmd FileType php hi! def link phpDocTags phpDefine
        " docblock comments italic
        autocmd FileType php hi! PreProc cterm=italic
    augroup END
endif
" }}}

" phpcomplete {{{
augroup mycompletephp
    autocmd!
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
augroup END
" default: 0. show more info in the preview window and return types. Slower.
" this also fails to parse the docblock sometimes which kills the whole
" completion
" let g:phpcomplete_parse_docblock_comments = 1

" turned this off because it makes jumping to definition slow :/
" let g:phpcomplete_enhance_jump_to_definition = 1/0 [default 1]
let g:phpcomplete_enhance_jump_to_definition = 0

" commented out because it slows down phpcomplete a lot
" adds additional built-in functions from php to the completable ones
" available extensions: https://github.com/shawncplus/phpcomplete.vim/blob/master/misc/available_extensions
" let g:phpcomplete_add_function_extensions = [
"     \ 'arrays',
"     \ 'strings',
"     \ 'urls',
"     \ 'filesystem',
"     \ 'curl',
"     \ 'json',
"     \ 'mail',
"     \ 'misc',
"     \ 'sessions',
" \ ]

" commented out...
" \ 'mysql',
" \ 'mysqli',

" commented out because it slows down phpcomplete a lot
" same for interfaces
" let g:phpcomplete_add_interface_extensions = [
"     \ 'predefined_interfaces_and_classes',
" \ ]

" don't try to complete this crap
let g:phpcomplete_remove_function_extensions = ['xslt_php_4']
let g:phpcomplete_remove_constant_extensions = ['xslt_php_4']

" complete these built-in functions, classes, etc.
" let g:phpcomplete_add_function_extensions = [...]
" let g:phpcomplete_add_class_extensions = [...]
" let g:phpcomplete_add_interface_extensions = [...]
" let g:phpcomplete_add_constant_extensions = [...]
" }}}

" phpfolding.vim {{{
let g:DisableAutoPHPFolding = 1
" }}}

" promptline.vim {{{
" PromptlineSnapshot! ~/.support/promptline.theme.bash airline_insert full
" }}}

" QFEnter {{{
let g:qfenter_vopen_map = ['v']
let g:qfenter_hopen_map = ['s']
let g:qfenter_topen_map = ['t']
let g:qfenter_keep_quickfixfocus = 0
" }}}

" snipbar {{{
if exists(':SnipBar') | nnoremap <leader>ss :SnipBar<CR> | endif
" }}}

" {{{ tagbar
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
" let g:tagbar_left = 1
" tagbar autofocus is the whole point of tagbar
if isdirectory(expand('~/.vim/plugged/tagbar')) | nnoremap <silent> <leader>tt :TagbarToggle<CR> | endif
" Configure Tagbar to user ripper-tags with ruby
let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'f:methods',
        \ 'F:singleton methods',
        \ 'C:constants',
        \ 'a:aliases'
    \ ],
    \ 'ctagsbin':  'ripper-tags',
    \ 'ctagsargs': ['-f', '-']
\ }
" }}}

" terminus {{{
set ttimeoutlen=0 " Timeout for escape sequences https://github.com/wincent/terminus/issues/9
" let g:TerminusBracketedPaste = 0
" }}}

" tender (color scheme) {{{
let g:tender_airline = 1
" }}}

" {{{ tmuxline
let g:airline#extensions#tmuxline#enabled = 0 " use current airline theme stuff when calling tmuxline
" let airline#extensions#tmuxline#color_template = 'replace' " when matching vim airline, use the color scheme from this mode

" let g:tmuxline_theme = 'vim_statusline_3' " the color theme

" let g:tmuxline_preset = 'full' " the layout and data to show
" a: session name
" b: hostname
" win: unselected tab
" cwin: current tab
" y: battery, docker machine status, haproxy status, socks proxy status
" z: date/time info
" \ 'b': ['#h'],
" \ 'options': {'status-justify': 'center'},
let g:tmuxline_preset = {
    \ 'a': ['❏ #S'],
    \ 'b': ["🔋 #(pmset -g batt | egrep '\d+%' | awk '{print $3}' | awk -F';' '{print $1}')"],
    \ 'c': ['#(~/.bin/saatchi-haproxy-status.sh)'],
    \ 'win': [ '#I', '#W'],
    \ 'cwin': ['#I', '#W#F'],
    \ 'y': ["#(TZ=Etc/UTC date '+%%R UTC')", ],
    \ 'z': ['%a', '%b %d', '%I:%M %p'],
\}
let g:airline#extensions#tmuxline#snapshot_file = '~/.tmuxline.conf'

if executable('tmux') && isdirectory(expand('~/.vim/plugged/tmuxline.vim'))
    " apply tmuxline settings and snapshot to file
    command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.support/tmuxline.conf
endif
" }}}

" {{{ ultisnips
" for things to expand with vim:
" https://vi.stackexchange.com/questions/104/how-can-i-see-the-full-path-of-the-current-file
let g:snips_author = 'Michael Funk <mike.funk@leafgroup.com>'
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsExpandTrigger='<c-l>' " Default: <Tab>
" let g:UltiSnipsExpandTrigger='<c-e>' " conflicts with cancel completion. Default: <Tab>
" let g:UltiSnipsListSnippets='<c-l>' " default: <c-Tab>
let g:UltiSnipsSnippetDirectories=['~/.vim/UltiSnips', 'UltiSnips']
" }}}"

" undoclosewin.vim {{{
if exists(':UcwRestoreWindow') | nnoremap <leader>uc :UcwRestoreWindow<cr> | endif
" }}}

" {{{ undotree
let g:undotree_SetFocusWhenToggle=1
if exists(':UndotreeToggle')
    silent! unmap <leader>u
    " toggle undotree window
    nnoremap <leader>uu :UndotreeToggle<CR>
endif
" }}}

" vdebug {{{
" NOTE: `:VdebugTrace $myvar` to sticky a variable value as you go. You
" can also write an expression there like `:VdebugTrace $x + 2`
" NOTE: <F12> to get var under cursor, <F11> to go back to context
" NOTE: eval visual selection in the watch window with `<leader>ev`. Eval
" custom expression with `:VdebugEval $x + 2`. It will go back to context on
" the next step unless you make it stick with `:VdebugEval! $x + 2`. In that
" case will re-evaluate at every step.
" NOTE: for repeating requests `:VdebugOpt continuous_mode 1`
let g:vdebug_options = {}
let g:vdebug_options['timeout'] = 30
let g:vdebug_options['watch_window_style'] = 'compact'
let g:vdebug_options['continuous_mode'] = 1
let g:vdebug_options['debug_file'] = '/tmp/xdebug.log'
let g:vdebug_options["break_on_open"] = 0 " (default = 1)

let g:vdebug_keymap = { 'eval_visual': '<leader>ev' }

" @link https://vi.stackexchange.com/questions/3355/why-do-custom-highlights-in-my-vimrc-get-cleared-or-reset-to-default
function! FixVdebugHighlights() abort
    hi DbgBreakptLine term=reverse ctermfg=Black ctermbg=Green guifg=#000000 guibg=#00ff00
    hi DbgBreakptSign term=reverse ctermfg=Black ctermbg=Green guifg=#000000 guibg=#00ff00
    hi DbgCurrentLine term=reverse ctermfg=White ctermbg=Red guifg=#ffffff guibg=#ff0000
    hi DbgCurrentSign term=reverse ctermfg=White ctermbg=Red guifg=#ffffff guibg=#ff0000
endfunction

augroup fix_vdebug_highlights_load
    autocmd!
    autocmd FileType * call FixVdebugHighlights()
augroup END

augroup fixvdebughighlights
    autocmd!
    autocmd ColorScheme * call FixVdebugHighlights()
augroup END

augroup vdebugwatchpanellarger
    autocmd!
    autocmd BufRead,BufNewFile DebuggerWatch resize 100
augroup END

" didn't work as just a command
function! ZendRoutingParams() abort
    :VdebugEval $this->getRequest()->getParams()
endfunction
command! ZendRoutingParams :call ZendRoutingParams()
" }}}

" {{{ vim-airline
" let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts=1 " airline use cool powerline symbols
let g:airline#extensions#whitespace#enabled = 1 " show whitespace warnings
let g:airline_highlighting_cache = 1 " cache syntax highlighting for better performance

" tabline
let g:airline#extensions#tabline#enabled = 1 " advanced tabline
let g:airline#extensions#tabline#close_symbol = '✕' " configure symbol used to represent close button
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" let g:airline#extensions#tabline#exclude_preview = 0
let g:airline#extensions#tabline#show_buffers = 0 " shows buffers when no tabs
let g:airline#extensions#tabline#show_splits = 0 " shows how many splits are in each tab
let g:airline#extensions#tabline#show_tab_type = 0 " right side says either 'buffers' or 'tabs'
let g:airline#extensions#tagbar#enabled = 0 " cool but slows down php

if isdirectory(expand('~/.vim/plugged/vim-airline'))
    " add asyncrun status for async tasks e.g. 'running' 'failure' 'success'
    if isdirectory(expand('~/.vim/plugged/asyncrun.vim'))
        function! AsyncrunAirlineInit() abort
            let g:airline_section_z = airline#section#create_right([
                \ '%{g:asyncrun_status} ' . g:airline_section_z
            \ ])
            " let g:airline_section_z = airline#section#create_right([
            "     \ '%{g:asyncrun_status}',
            "     \ g:airline_section_z
            " \ ])
        endfunction
        augroup asyncrun_airline_augroup
            autocmd!
            autocmd User AirlineAfterInit call AsyncrunAirlineInit()
        augroup END
    endif
endif


" }}}

" vim-better-whitespace {{{
" Set this to disable highlighting of the current line in all modes
" This setting will not have the performance impact of the above, but
" highlighting throughout the file may be overridden by other highlight
" patterns with higher priority.
let g:current_line_whitespace_disabled_soft = 1
" }}}

" vim-bookmarks {{{
let g:bookmark_no_default_key_mappings = 1
" }}}

" vim-colorscheme-switcher {{{
let g:colorscheme_switcher_exclude_builtins = 1
" only because shift-F8 is already mapped
let g:colorscheme_switcher_define_mappings = 0
if isdirectory(expand('~/.vim/plugged/vim-colorscheme-switcher'))
    nnoremap <F7> :PrevColorScheme<cr>
    nnoremap <F8> :NextColorScheme<cr>
endif
" }}}

" vim-commentary {{{
augroup commentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
    autocmd FileType haproxy setlocal commentstring=#\ %s
    autocmd FileType neon setlocal commentstring=#\ %s
    autocmd FileType gitconfig setlocal commentstring=#\ %s
augroup END
if isdirectory(expand('~/.vim/plugged/vim-commentary'))
    " this is for my muscle memory from nerd-commenter, but try to get used to
    " gcc or gc(motion) instead (like gcap)
    nnoremap <leader>c<space> :Commentary<cr>
    vnoremap <leader>c<space> :Commentary<cr>
endif
" }}}

" vim-fix-my-js {{{
let g:fixmyjs_use_local = 1
if isdirectory(expand('~/.vim/plugged/vim-fix-my-js')) | noremap <Leader>jf :Fixmyjs<CR> | endif
" }}}

" vim-flow {{{
let g:flow#enable = 0 " disable flow linting - ale handles that
let g:flow#omnifunc = 1
let g:flow#timeout = 4 " increase timeout to avoid errors on init
" }}}

" vim-fugivite {{{
" cd to git root: :Gcd
let g:fugitive_git_executable = 'git -c "color.ui=never"' " Why is this not default?
if isdirectory(expand('~/.vim/plugged/vim-fugitive'))
    nnoremap <leader>gpl :Gpull<cr>
    nnoremap <leader>gps :Gpush<cr>
    nnoremap <leader>gs :Gstatus<cr>
    nnoremap <leader>gw :Gwrite<cr>
    nnoremap <leader>gr :Gread<cr>
    nnoremap <leader>gbl :Gblame<cr>
    nnoremap <leader>gbr :Gbrowse<cr>
    nnoremap <leader>gl :Glog<cr>
    nnoremap <leader>gm :Gmove<space>
    nnoremap <leader>go :Git co<space>
    nnoremap <leader>ge :Gedit<cr>
    nnoremap <Leader>g- :Git stash<CR>:e<CR>
    nnoremap <Leader>g+ :Git stash apply<CR>:e<CR>
    " nnoremap <leader>gc :!git add -A<cr> :Gcommit<cr>
    nnoremap <leader>gc :Gcommit<cr>
    command! WorkingCommit :!git add -A && git commit -m 'working'<cr>
endif
" }}}

" vim-http-client {{{
let g:http_client_bind_hotkey = 0 " (default 1)
let g:http_client_focus_output_window = 0
" if isdirectory(expand("~/.vim/plugged/vim-http-client"))
"     nnoremap <leader>pp :HTTPClientDoRequest<cr>
" endif
" }}}

" vim-gitgutter {{{
" let g:gitgutter_sign_column_always = 1
let g:gitgutter_realtime = 0 | let g:gitgutter_eager = 0 " trade accuracy for speed. Only on save.
" }}}

" vim-gutentags {{{
" if isdirectory(expand("~/.vim/plugged/vim-gutentags"))
"     nnoremap <leader>gu :execute 'GutentagsUpdate!'<cr>:redraw!<cr>
" else
"     nnoremap <leader>gu :AsyncRun ctags -R .<cr>
" endif
" let g:gutentags_ctags_executable_php = '( git ls-files --ignored --exclude-standard | ctags --links=no -L- )'
" let g:gutentags_ctags_executable_php = '( ag -l | ctags --links=no -L- )'
let g:gutentags_ctags_executable_ruby = 'ripper-tags -R'

" I pass gitignore to wildignore with another plugin. This defaults to 1, so
" if I left it in the default, gutentags would not tag any vendor files :/
let g:gutentags_ctags_exclude_wildignore = 0

" only tag stuff that is not in gitignore
" downside: you have to commit a file for it to be tagged
" let g:gutentags_file_list_command = {
"     \ 'markers': {
"         \ '.git': 'git ls-files',
"         \ '.hg': 'hg files',
"         \ },
"     \ }

" this is because of the following comment by phpcomplete project owner
" shawncplus: I'd advise against regenerating tag files on every save or
" file-change because the plugin tries to cache results as much as possible
" and uses the tag file's mtime to invalidate those caches (maybe doing it on
" git commits with a hook in the repo could be a nice balance of freshness and
" speed).
" https://github.com/shawncplus/phpcomplete.vim/issues/102#issuecomment-308183080
" let g:gutentags_generate_on_write = 0
" let g:gutentags_generate_on_missing = 0
" let g:gutentags_generate_on_new = 0
" let g:gutentags_generate_on_empty_buffer = 0

" cscope module doesn't work yet
" let g:gutentags_modules = ['ctags']
" if executable('cscope') && has('cscope') | call add(g:gutentags_modules, 'cscope') | endif
let g:gutentags_ctags_exclude = [
    \ '.git',
    \ '*.log',
    \ '*.min.js',
    \ '*.coffee',
    \ 'bootstrap.php.cache',
    \ 'classes.php.cache',
    \ 'app/cache',
    \ '__TwigTemplate_*'
\]
" }}}

" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_default_mapping = 0
let g:indent_guides_exclude_filetypes = ['help', 'startify']
if (has('termguicolors') && &termguicolors == 0)
    let g:indent_guides_auto_colors = 0
    hi IndentGuidesOdd  ctermbg=235
    hi IndentGuidesEven ctermbg=234
endif
" }}}

" {{{ vim-indentline
let g:indentLine_char = '┆'
let g:indentLine_faster = 1
" let g:indentLine_setConceal = 0
" }}}

" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1 " enable jsdoc syntax highlighting
let g:javascript_plugin_flow = 1 " enable flowtype syntax highlighting
" }}}

" vim-lost {{{
augroup lostgrp
    autocmd!
    autocmd FileType php let b:lost_regex = '\v^    \w+.*function'
augroup END
" }}}

" vim-lotr {{{
if isdirectory(expand('~/.vim/plugged/vim-lotr')) | nnoremap <leader>ll :LOTRToggle<cr> | endif
" }}}

" vim-lsp {{{
if isdirectory(expand('~/.vim/plugged/vim-lsp'))
    augroup lsp_group
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'php-language-server',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, 'php ~/.composer/vendor/bin/php-language-server.php', '--stdio']},
            \ 'whitelist': ['php'],
        \ })
        autocmd FileType php setlocal omnifunc=lsp#complete
    augroup END
endif
" }}}

" vim-mundo {{{
let g:mundo_close_on_revert = 1
if isdirectory(expand('~/.vim/plugged/vim-mundo'))
    silent! unmap <leader>u
    " toggle undotree window
    nnoremap <leader>uu :MundoToggle<CR>
endif
" }}}

" vim-pasta {{{
let g:pasta_disabled_filetypes = ['netrw']
" }}}

" vim-phpfmt {{{
let g:phpfmt_autosave = 0 " default: 1 autoformats with phpcbf on save
if isdirectory(expand('~/.vim/plugged/vim-phpfmt'))
    command! FormatPhp PhpFmt
endif
" }}}

" {{{ vim-php-namespace
let g:php_namespace_sort_after_insert = 1 " auto sort use after inserting use statement
if isdirectory(expand('~/.vim/plugged/vim-php-namespace'))
    " php add use statement for current class
    augroup phpnamespacegroup
        autocmd!
        autocmd FileType php inoremap <Leader><Leader>u <C-O>:call PhpInsertUse()<CR>
        autocmd FileType php nnoremap <Leader><Leader>u :call PhpInsertUse()<CR>
        " expand the namespace for the current class name
        autocmd FileType php inoremap <Leader><Leader>e <C-O>:call PhpExpandClass()<CR>
        autocmd FileType php nnoremap <Leader><Leader>e :call PhpExpandClass()<CR>
    augroup END
endif
" }}}

" vim-phpqa {{{
let g:phpqa_messdetector_autorun = 0 "default: 1
let g:phpqa_codesniffer_autorun = 0 "default: 1
let g:phpqa_codecoverage_autorun = 0 "default: 1
let g:phpqa_open_loc = 0 "default: 1
" }}}

" vim-plug {{{
" Install any newly added plugins in ~/.vimrc.plugins
if exists(':PlugInstall') | nnoremap <leader>bi :Source<cr> :PlugInstall<cr> | endif
" Remove any newly removed plugins in ~/.vimrc.plugins
if exists(':PlugClean') | nnoremap <leader>bc :Source<cr> :PlugClean!<cr> | endif
" Upgrade all installed plugins in ~/.vimrc.plugins
if exists(':PlugUpdate') | nnoremap <leader>bu :Source<cr> :PlugUpdate<cr> :PlugUpgrade<cr> silent! :UpdateRemotePlugins<cr> | endif
" }}}

" vim-polyglot {{{
let g:polyglot_disabled=['php'] " I use a different php syntax plugin
" }}}

" vim-rest-console {{{
" aka vim-rest-client
" let g:vrc_show_command = 1 " display the actual curl command being run when
" firing http requests
" let g:vrc_connect_timeout = 9999 " ignore timeout for xdebug (v2.x.x version)
" -sS is to keep it from showing the progress bar
" -i is to show response headers
let g:vrc_curl_opts = {
            \ '--connect-timeout': 9999,
            \ '-sS': '',
            \ '-i': '',
            \ '': '-L',
            \ }
let g:vrc_response_default_content_type = 'json'
" sometimes the output is html but the default type is json so it looks like
" crap.
if isdirectory(expand('~/.vim/plugged/vim-rest-console'))
    command! RestJson let b:vrc_response_default_content_type = 'application/json'
    command! RestXml let g:vrc_response_default_content_type = 'text/xml'
endif
" let g:vrc_auto_format_response_enabled = 1 " enabled by default
" let g:vrc_split_request_body = 1 " allow each line to be key=value after GET /my/url. NOTE: this breaks PUT requests with bodies!
" let g:vrc_cookie_jar = '/tmp/vrc_cookie_jar'
" }}}

" vim-notes {{{
let g:notes_directories = ['~/notes']
" }}}

" vim-php-refactoring {{{
let g:php_refactor_command='refactor'
" }}}

" vim-php-refactoring-toolbox {{{
" http://kushellig.de/neovim-php-ide/#write-less-messy-code-with-neomake
" }}}

" vim-slash {{{
if isdirectory(expand('~/.vim/plugged/vim-slash')) && isdirectory(expand('~/.vim/plugged/vim-indexed-search'))
    let g:indexed_search_mappings = 0
    noremap <Plug>(slash-after) :ShowSearchIndex<CR>
endif
" }}}

" {{{ vim-startify
if (has('nvim'))
    let g:startify_custom_header = [
        \ '                             _',
        \ '      ____  ___  ____ _   __(_)___ ___',
        \ '     / __ \/ _ \/ __ \ | / / / __ `__ \',
        \ '    / / / /  __/ /_/ / |/ / / / / / / /',
        \ '   /_/ /_/\___/\____/|___/_/_/ /_/ /_/',
        \ '',
        \ '',
        \ ]
else
    let g:startify_custom_header = [
        \ '                                  __         __',
        \ '            __                  /''_ `\     /''__`\',
        \ '    __  __ /\_\    ___ ___     /\ \L\ \   /\ \/\ \',
        \ '   /\ \/\ \\/\ \ /'' __` __`\   \/_> _ <_  \ \ \ \ \',
        \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \    /\ \L\ \__\ \ \_\ \',
        \ '    \ \___/  \ \_\ \_\ \_\ \_\   \ \____/\_\\ \____/',
        \ '     \/__/    \/_/\/_/\/_/\/_/    \/___/\/_/ \/___/',
        \ '',
        \ '',
        \ ]


endif

" a list if files to always bookmark. Will be shown at bottom
" of the startify screen.
let g:startify_bookmarks = [ '~/.vimrc', '~/.vimrc.plugins' ]
let g:startify_change_to_vcs_root = 1 " always cd to git root on startup

" disable common but unimportant files
let g:startify_skiplist = [ 'COMMIT_EDITMSG', '\.DS_Store' ]
" below disabled because I now use vim-obsession
" let g:startify_session_autoload = 1 " autoload Session.vim in the current dir
" let g:startify_session_persistence = 1 " auto save session on exit like obsession
" }}}"

" vim-tbone {{{
if isdirectory(expand('~/.vim/plugged/vim-tbone'))
    " highlight text and g> to send text to bottom right split. Useful for sql window.
    nnoremap g> <ESC>vap:Twrite bottom-right<CR>
    xnoremap g> :Twrite bottom-right<CR>
endif
" }}}

" vim-test {{{
" let test#php#phpunit#options = '--testdox'
" let test#php#phpunit#options = '--colors=never'
" if isdirectory(expand("~/.vim/plugged/asyncrun.vim")) | let test#strategy = 'asyncrun' | endif
if isdirectory(expand('~/.vim/plugged/vimux')) | let g:test#strategy = 'vimux' | endif
if isdirectory(expand('~/.vim/plugged/vim-test'))
    nnoremap <silent> <leader>tn :TestNearest<CR>
    nnoremap <silent> <leader>tf :TestFile<CR>
    nnoremap <silent> <leader>ts :TestSuite<CR>
    " nnoremap <silent> <leader>tl :TestLast<CR>
    " nnoremap <silent> <leader>tv :TestVisit<CR>
endif
" }}}

" vimux {{{
let g:VimuxHeight = '40'
if isdirectory(expand('~/.vim/plugged/vimux')) && executable('tmux')
    " nnoremap <leader>vp :VimuxPromptCommand<cr>
    " open vimux window at the current directory and focus it
    " nnoremap <leader>vc :VimuxPromptCommand<cr>cd $PWD<cr>:VimuxInspectRunner<cr>
    " nnoremap <leader>vl :VimuxRunLastCommand<cr>
    " nnoremap <leader>vv :VimuxRunLastCommand<cr>
    " nnoremap <leader>vr :VimuxRunLastCommand<cr>
    " nnoremap <leader>vi :VimuxInspectRunner<cr>
    " nnoremap <leader>vx :VimuxCloseRunner<cr>
    " nnoremap <leader>vz :VimuxZoomRunner<cr>

    " poor man's phpunit runner for current test file
    nnoremap <leader>pw :call VimuxRunCommand("clear; puwatch " . bufname("%"))<CR>
    nnoremap <leader>pf :call VimuxRunCommand("clear; puwatch --filter=" . <c-r><c-w><CR>
    nnoremap <leader>sw :call VimuxRunCommand("clear; pswatch " . bufname("%"))<CR>
    nnoremap <leader>sl :call VimuxRunCommand("clear; pswatch " . bufname("%") . ":" . (line(".") + 1))<CR>
endif
" }}}

" vimwiki {{{
" <Leader>ww opens the first wiki from |g:vimwiki_list|.
" [count]<Leader>wt or <Plug>VimwikiTabIndex
" <Leader>ws or <Plug>VimwikiUISelect
" [count]<Leader>wi or <Plug>VimwikiDiaryIndex Open diary index file of the [count]'s wiki.
" [count]<Leader>w<Leader>w or <Plug>VimwikiMakeDiaryNote Open diary wiki-file for today of the [count]'s wiki.
let g:vimwiki_list = [{'path': '~/.private-stuff/notes/', 'syntax': 'markdown', 'ext': '.md'}]
if isdirectory(expand('~/.vim/plugged/vimwiki'))
    command! Note :e ~/.private-stuff/notes/saatchiart/
endif
let g:vimwiki_folding = 'expr'
let g:vimwiki_ext2syntax = { '.md': 'markdown' }
" }}}
