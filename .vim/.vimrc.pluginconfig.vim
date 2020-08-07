" configuration for plugins I use
" vim: set foldmethod=marker filetype=vim:
scriptencoding utf-8

" accelerated-smooth-scroll {{{
let g:ac_smooth_scroll_min_limit_msec = 80 " confusiong option to speed up scrolling with slow rendering. default is 50.
" }}}

" ale {{{
" aka vim-ale or ale.vim

" intelephense {{{
" add intelephense linter for php
" based on https://github.com/dense-analysis/ale/blob/master/ale_linters/php/langserver.vim
if has_key(g:plugs, 'ale') && executable('intelephense')
    call ale#Set('php_intelephense_executable', 'intelephense')
    call ale#Set('php_intelephense_use_global', get(g:, 'ale_use_global_executables', 1))

    " same config as for nvim-lsp
    call ale#linter#Define('php', {
                \  'name': 'intelephense',
                \  'lsp': 'stdio',
                \  'lsp_config': {
                \    'environment': {
                \      'phpVersion': "7.0.0",
                \    },
                \    'completion': {
                \      'insertUseDeclaration': v:true,
                \      'fullyQualifyGlobalConstantsAndFunctions': v:true
                \    },
                \    'stubs': [
                \      "apache",
                \      "bcmath",
                \      "bz2",
                \      "calendar",
                \      "com_dotnet",
                \      "Core",
                \      "ctype",
                \      "couchbase",
                \      "curl",
                \      "date",
                \      "dba",
                \      "dom",
                \      "enchant",
                \      "exif",
                \      "fileinfo",
                \      "filter",
                \      "fpm",
                \      "ftp",
                \      "gd",
                \      "hash",
                \      "iconv",
                \      "imap",
                \      "interbase",
                \      "intl",
                \      "json",
                \      "ldap",
                \      "libxml",
                \      "mbstring",
                \      "mcrypt",
                \      "memcached",
                \      "meta",
                \      "mssql",
                \      "mysqli",
                \      "oci8",
                \      "odbc",
                \      "openssl",
                \      "pcntl",
                \      "pcre",
                \      "PDO",
                \      "pdo_ibm",
                \      "pdo_mysql",
                \      "pdo_pgsql",
                \      "pdo_sqlite",
                \      "pgsql",
                \      "Phar",
                \      "posix",
                \      "pspell",
                \      "readline",
                \      "recode",
                \      "redis",
                \      "Reflection",
                \      "regex",
                \      "session",
                \      "shmop",
                \      "SimpleXML",
                \      "snmp",
                \      "soap",
                \      "sockets",
                \      "sodium",
                \      "SPL",
                \      "sqlite3",
                \      "standard",
                \      "superglobals",
                \      "sybase",
                \      "sysvmsg",
                \      "sysvsem",
                \      "sysvshm",
                \      "tidy",
                \      "tokenizer",
                \      "wddx",
                \      "xml",
                \      "xmlreader",
                \      "xmlrpc",
                \      "xmlwriter",
                \      "Zend OPcache",
                \      "zip",
                \      "zlib"
                \    ]
                \  },
                \  'executable': {b -> ale#node#FindExecutable(b, 'php_intelephense', [
                \      'node_modules/.bin/intelephense',
                \  ])},
                \  'command': '%e --stdio',
                \  'project_root': function('ale_linters#php#langserver#GetProjectRoot'),
                \})
endif
" }}}

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
let g:ale_lint_on_enter = 0
" let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'

" let g:ale_fix_on_save = 1 " This is off by default. You could do it manually with :ALEFix
let g:ale_php_cs_fixer_options = '--config=.php_cs'

let g:ale_sign_column_always = 1 " otherwise screen keeps jumping left and right
let g:airline#extensions#ale#error_symbol = 'Errors:' " default is a bit sparse: E
" let g:airline#extensions#ale#error_symbol = '🛑'
let g:airline#extensions#ale#warning_symbol = 'Warnings:'
" let g:airline#extensions#ale#warning_symbol = '⚠️' " default is W
let g:zenburn_high_Contrast = 1
let g:ale_virtualtext_cursor = 1
" let g:ale_change_sign_column_color = 1

" mappings {{{
if has_key(g:plugs, 'ale')
    nmap <silent> [w <Plug>(ale_previous_wrap)
    nmap <silent> ]w <Plug>(ale_next_wrap)
    nnoremap <leader>al :ALELint<cr>
    nnoremap <leader>af :ALEFix<cr>
endif
" }}}

" hover {{{
" :h ale-hover
" Example mouse settings.
" You will need to try different settings, depending on your terminal.
" set mouse=a
" set ttymouse=xterm
" let g:ale_set_balloons = 1
let g:ale_hover_to_preview = 1

" let g:preview_window_is_open = 0
" function! TriggerALEHover () abort
"     if g:preview_window_is_open
"         :pclose
"         let g:preview_window_is_open = 0
"         return
"     endif
"     :ALEHover
"     let g:preview_window_is_open = 1
" endfunction

" moved to palette due to legacy, etc.
" if has_key(g:plugs, 'ale')
"     nnoremap <c-k> :call TriggerALEHover()<cr>
" endif
" }}}

" completion {{{
" :h ale-completion
" Finally got ale completion to work! It's laggy though, I'd rather run it
" through neovim in lua.
" let g:ale_completion_enabled = 1
" set completeopt=menu,menuone,preview,noselect,noinsert

" Use ALE's function for omnicompletion.
" autocmd FileType php setlocal omnifunc=ale#completion#OmniFunc
"
" if has_key(g:plugs, 'ale')
    " doesn't do anything in intelephense... paid feature?
    " nnoremap <c-[> :ALEGoToTypeDefinition<cr>
    " nnoremap <c-w><c-[> :vsp<cr>:ALEGoToTypeDefinition<cr>

    " function! OpenTypeInNewTab () abort
    "     :normal! mz
    "     :tabe %
    "     :normal! `z
    "     :AleGoToTypeDefinition
    " endfunction

    " nnoremap <leader><c-[> :tabe %<cr>:call OpenTypeInNewTab()<cr>
" endif

let g:ale_completion_symbols = {
            \ 'text': '',
            \ 'method': '',
            \ 'function': '',
            \ 'constructor': '',
            \ 'field': '',
            \ 'variable': '',
            \ 'class': '',
            \ 'interface': '',
            \ 'module': '',
            \ 'property': '',
            \ 'unit': 'unit',
            \ 'value': 'val',
            \ 'enum': '',
            \ 'keyword': 'keyword',
            \ 'snippet': '',
            \ 'color': 'color',
            \ 'file': '',
            \ 'reference': 'ref',
            \ 'folder': '',
            \ 'enum member': '',
            \ 'constant': '',
            \ 'struct': '',
            \ 'event': 'event',
            \ 'operator': '',
            \ 'type_parameter': 'type param',
            \ '<default>': 'v'
            \ }
" }}}

" }}}

" base16-vim {{{
" set the default color scheme
if has_key(g:plugs, 'base16-vim')
    silent! colorscheme base16-atlas " very solarized-y but more colorful
endif
let g:airline_theme = 'base16'
" }}}

" asyncomplete.vim {{{
" for asyncomplete.vim log
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')
" allow modifying the completeopt variable, or it will
" be overridden all the time
let g:asyncomplete_auto_completeopt = 0

" ale + asyncomplete {{{
" if has_key(g:plugs, 'ale') && has_key(g:plugs, 'asyncomplete.vim')
"     augroup ale_asyncomplete
"         autocmd!
"         autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
"             \ 'priority': 10,
"             \ }))
"     augroup END
" endif
" }}}

" }}}

" asyncomplete-buffer.vim {{{
if has_key(g:plugs, 'asyncomplete.vim') && has_key(g:plugs, 'asyncomplete-buffer.vim')
    call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                \ 'name': 'buffer',
                \ 'allowlist': ['*'],
                \ 'blocklist': ['go'],
                \ 'completor': function('asyncomplete#sources#buffer#completor'),
                \ 'config': {
                \    'max_buffer_size': 5000000,
                \  },
                \ }))
endif
" }}}

" asyncomplete-omni.vim {{{
if has_key(g:plugs, 'asyncomplete-omni.vim')
    call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
                \ 'name': 'omni',
                \ 'whitelist': ['*'],
                \ 'blacklist': ['c', 'cpp', 'html'],
                \ 'completor': function('asyncomplete#sources#omni#completor')
                \  }))
endif
" }}}

" asyncrun.vim {{{
if has_key(g:plugs, 'asyncrun.vim')
    " trying to search without the annoying neovim bug
    " but it still exists in these commands. ARGH
    " nnoremap <leader>gg :AsyncRun! -strip -program=grep<space>
    " nnoremap <leader>gg :AsyncRun! -strip ag --vimgrep<space>

    nnoremap <leader>qq :call asyncrun#quickfix_toggle(8)<cr>
    if has_key(g:plugs, 'vim-fugitive')
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

" chadtree {{{
if has_key(g:plugs, 'chadtree')
    nnoremap - :CHADopen<cr>
endif
" }}}

" challenger-deep-theme {{{
let g:challenger_deep_termcolors = 16
" }}}

" coc.nvim {{{
if has_key(g:plugs, 'coc.nvim')

    " Use <c-space> for trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " tab completion {{{
    " Use tab for trigger completion with characters ahead and navigate. Use
    " command ':verbose imap <tab>' to make sure tab is not mapped by other
    " plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <cr> for confirm completion, `<C-g>u` means break undo chain at
    " current position. Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " }}}

    " Remap keys for gotos
    nnoremap <silent> gd <Plug>(coc-definition)
    nnoremap <silent> gy <Plug>(coc-type-definition)
    nnoremap <silent> gi <Plug>(coc-implementation)
    nnoremap <silent> gr <Plug>(coc-references)

    " Remap for rename current word
    nnoremap <leader>rn <Plug>(coc-rename)

    augroup cocgroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType php,json,javascript setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
    let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
endif
" }}}

" coc-sources {{{
" if has_key(g:plugs, 'coc-sources')
"     :CocInstall coc-omni
"     :CocInstall coc-tag
"     :CocInstall coc-ultisnips
" endif
" }}}

" completion-nvim {{{
if has_key(g:plugs, 'completion-nvim')

    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " Set completeopt to have a better completion experience
    set completeopt=menuone,noinsert,noselect

    " Avoid showing message extra message when using completion
    set shortmess+=c
endif
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
" make emmet behave well with JSX in JS and TS files
let g:user_emmet_settings = {
            \  'javascript' : {
            \      'extends' : 'jsx',
            \  },
            \  'typescript' : {
            \      'extends' : 'tsx',
            \  },
            \}
" }}}

" float-preview {{{
" https://github.com/ncm2/float-preview.nvim
let g:float_preview#docked = 0
" }}}

" fzf.vim {{{
" this was making it ignore .agignore too :/
let $FZF_DEFAULT_COMMAND = 'ag --files-with-matches --skip-vcs-ignores -g ""'
" let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

" go to tab/window or open in new tab with ctrl-t
" https://www.reddit.com/r/vim/comments/9ifsjf/vim_fzf_question_about_switching_to_already_open/e6k5cp0/
function! s:GotoOrOpen(command, ...)
  for file in a:000
    if a:command == 'e'
      exec 'e ' . file
    else
      exec "tab drop " . file
    endif
  endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)

let g:fzf_action = {
  \ 'ctrl-t': 'GotoOrOpen tab',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }
let g:fzf_buffers_jump = 1 " Jump to the existing window if possible

if has_key(g:plugs, 'fzf.vim')
    " :Ag  - Start fzf with hidden preview window that can be enabled with ? key
    " :Ag! - Start fzf in fullscreen and display the preview window above
    command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%', '?'), <bang>0)
    " Likewise, :Files command with preview window
    command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    " :HFiles - Files in the git staging area
    command! -count=1 HFiles call fzf#run({ 'source': 'git log HEAD -n <count> --diff-filter=MA --name-only --pretty=format: | sed -e /^$/d'})

    " FZF Most recent files
    command! MRU call fzf#run({
                \ 'source':  reverse(s:all_files()),
                \ 'sink':    'edit',
                \ 'options': '-m -x +s',
                \ 'down':    '40%' })
    " this conflicts with php refactoring
    " nnoremap <leader>rr :MRU<cr>

    function! s:all_files()
        return extend(
                    \ filter(copy(v:oldfiles),
                    \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
                    \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
    endfunction

    nnoremap <leader>ag :Ag<cr>
    nnoremap <leader>ff :Files<cr>
    " I remap this in palette
    nmap <leader>tt :Tags<cr>

    " nnoremap <leader>bb :Buffers<cr>
    " nnoremap <leader>hh :History<cr>
    nnoremap <leader>hh :Helptags<cr>
    " see `:h vim-fzf-commands` for all available commands
endif

" fzf in floating window. see :help fzf
" if has('nvim')
"   let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'

"   function! FloatingFZF()
"     let width = float2nr(&columns * 0.9)
"     let height = float2nr(&lines * 0.6)
"     let opts = { 'relative': 'editor',
"                \ 'row': (&lines - height) / 2,
"                \ 'col': (&columns - width) / 2,
"                \ 'width': width,
"                \ 'height': height }

"     let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
"     call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
"   endfunction

"   let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" endif
" }}}

" fzf-mru.vim {{{
" only show MRU files from within your cwd
let g:fzf_mru_relative = 1
" }}}

" fzf-preview.vim {{{
if has_key(g:plugs, 'fzf-preview.vim')
    let g:fzf_layout = { 'window': 'call fzf_preview#window#create_centered_floating_window()' }
endif
" }}}

" gist-vim {{{
if has_key(g:plugs, 'gist-vim')
    nnoremap <leader>gi :Gist<cr>
endif
" }}}

" git-messenger.vim {{{
let g:git_messenger_always_into_popup = 1
let g:git_messenger_no_default_mappings = 1
if has_key(g:plugs, 'git-messenger.vim')
    nnoremap <leader>mm :GitMessenger<cr>
endif
" }}}

" goyo.vim + limelight.vim {{{
" https://github.com/junegunn/dotfiles/blob/5a152686a9456e3713c5b0d4abc7798607db1979/vimrc#L1213
let g:limelight_paragraph_span = 1

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  " hi NonText ctermfg=101
  Limelight
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  Limelight!
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd  User GoyoEnter nested call <SID>goyo_enter()
autocmd  User GoyoLeave nested call <SID>goyo_leave()
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

" languageClient-neovim {{{
let g:LanguageClient_autoStart = 1
" don't spam the quickfix with lsp diagnostics
let g:languageClient_diagnosticsList = 'Disabled'
" this is now handled by 'roxma/LanguageServer-php-neovim'
let g:LanguageClient_serverCommands = {
            \ 'php': [$HOME . '/.bin/php-language-server'],
            \ }
" \ 'php': [$HOME.'/.bin/intelephense-server'],
if has_key(g:plugs, 'LanguageClient-neovim')
    augroup language_client_neovim_augroup
        autocmd!
        autocmd filetype php set completefunc=LanguageClient#complete
    augroup END
    let g:airline#extensions#languageclient#enabled = 1
    nnoremap <leader>zz :call LanguageClient_contextMenu()<cr>
endif
" }}}

" line-number-interval.nvim {{{
" Enable line number interval at startup. (default: 0(disable))
let g:line_number_interval#enable_at_startup = 1

" Set interval to highlight line number. (default: 10)
let g:line_number_interval = 5
" }}}

" MatchTagAlways {{{
if has_key(g:plugs, 'MatchTagAlways')
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
if has_key(g:plugs, 'vim-mucomplete')
    " set completeopt+=menuone
    set shortmess+=c
    " set completeopt+=noinsert,noselect " For automatic completion
endif
" }}}

" nerdcommenter {{{
" extra space in NERDCommenter comments
let g:NERDSpaceDelims='1'

" let g:NERDCustomDelimiters = {
            " \ 'php': {
            " \ 'left': '/**',
            " \ 'right': '*/'
            " \ }
            " \ }
" }}}

" NERDTree {{{
" I switched from NERDTree to netrw years ago but I'm tired of the bugs and
" believe it or not, I actually want a sidebar file explorer again. Also this
" integrates with devicons, which is a plus.
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeQuitOnOpen = 1
if has_key(g:plugs, 'nerdtree')
    augroup nerdtree_autocmds
        autocmd!

        " close nerdtree if it's the last thing open
        autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

        nnoremap <leader>ee :NERDTreeToggleVCS<cr>
        " netrw-like
        nnoremap - :NERDTreeFind<cr>
    augroup END
endif
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
" let g:neoformat_enabled_javascript = ['prettiereslint']
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

" nnn.vim {{{
if has_key(g:plugs, 'nvim-lsp')
    nnoremap - :NnnPicker %<cr>
    nnoremap <leader>ee :NnnPicker<cr>
    command! -bang -nargs=* -complete=file Ex NnnPicker <args>
    command! -bang -nargs=* -complete=file Explore NnnPicker <args>
endif
let g:nnn#replace_netrw = 1
let g:nnn#set_default_mappings = 0
let g:nnn#action = {
            \ '<c-t>': 'tab split',
            \ '<c-s>': 'split',
            \ '<c-v>': 'vsplit'
            \ }
" }}}

" nvim-lsp {{{
if has_key(g:plugs, 'nvim-lsp')
    " example config from :help lsp:
    " nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
    " nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    " nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    " nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    " nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    " nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    " nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>

    " working for palette, legacy, etc!
    " NOTE: `:LspInstall intelephense` doesn't play nice with asdf
    if executable('intelephense')

        " https://github.com/Mte90/dotfiles/blob/master/.vim/custom/custom-lsp.vim
        " available stubs: https://github.com/JetBrains/phpstorm-stubs
        " added: couchbase, redis, memcached

lua <<EOF
    local nvim_lsp = require'nvim_lsp'
    nvim_lsp.intelephense.setup{
        settings = {
            intelephense = {
                environment = {
                    phpVersion = "7.0.0"
                },
                completion = {
                    insertUseDeclaration = true,
                    fullyQualifyGlobalConstantsAndFunctions = true
                },
                stubs = {
                    "apache",
                    "bcmath",
                    "bz2",
                    "calendar",
                    "com_dotnet",
                    "Core",
                    "ctype",
                    "couchbase",
                    "curl",
                    "date",
                    "dba",
                    "dom",
                    "enchant",
                    "exif",
                    "fileinfo",
                    "filter",
                    "fpm",
                    "ftp",
                    "gd",
                    "hash",
                    "iconv",
                    "imap",
                    "interbase",
                    "intl",
                    "json",
                    "ldap",
                    "libxml",
                    "mbstring",
                    "mcrypt",
                    "memcached",
                    "meta",
                    "mssql",
                    "mysqli",
                    "oci8",
                    "odbc",
                    "openssl",
                    "pcntl",
                    "pcre",
                    "PDO",
                    "pdo_ibm",
                    "pdo_mysql",
                    "pdo_pgsql",
                    "pdo_sqlite",
                    "pgsql",
                    "Phar",
                    "posix",
                    "pspell",
                    "readline",
                    "recode",
                    "redis",
                    "Reflection",
                    "regex",
                    "session",
                    "shmop",
                    "SimpleXML",
                    "snmp",
                    "soap",
                    "sockets",
                    "sodium",
                    "SPL",
                    "sqlite3",
                    "standard",
                    "superglobals",
                    "sybase",
                    "sysvmsg",
                    "sysvsem",
                    "sysvshm",
                    "tidy",
                    "tokenizer",
                    "wddx",
                    "xml",
                    "xmlreader",
                    "xmlrpc",
                    "xmlwriter",
                    "Zend OPcache",
                    "zip",
                    "zlib"
                }
            }
        }
    }
EOF

        " if (has_key(g:plugs, 'completion-nvim'))
        "     lua require'nvim_lsp'.intelephense.setup{on_attach=require'completion'.on_attach}
        " else
        "     lua require'nvim_lsp'.intelephense.setup{}
        " endif

        " moved to palette vimrc because of legacy, zed, etc.
        " augroup nvim_lsp_php
        "     autocmd!
        "     autocmd filetype php setlocal omnifunc=v:lua.vim.lsp.omnifunc
        " augroup END

    endif

    " so far this is not working, it's just failing silently for catalog.
    if (executable('solargraph'))
        lua require'nvim_lsp'.solargraph.setup{}
        augroup nvim_lsp_ruby
            autocmd!
            autocmd filetype ruby setlocal omnifunc=v:lua.vim.lsp.omnifunc
        augroup END
    endif

    if (executable('docker-langserver'))
        lua require'nvim_lsp'.solargraph.setup{}
        augroup nvim_lsp_docker
            autocmd!
            autocmd filetype docker setlocal omnifunc=v:lua.vim.lsp.omnifunc
        augroup END
    endif

    " moved this to easel .vimrc ... legacy doesn't have flow and gallery's
    " version is so old it doesn't have lsp.
    " require'nvim_lsp'.flow.setup{}

endif
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
if has_key(g:plugs, 'pdv')
    " document the current element with php documentor for vim
    augroup pdvgroup
        autocmd!
        autocmd FileType php nnoremap <leader>pd :call pdv#DocumentWithSnip()<CR>
    augroup END
endif
" }}}

" phpcd {{{
if has_key(g:plugs, 'deoplete.nvim') && has_key(g:plugs, 'phpcd.vim')
    let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
    let g:deoplete#ignore_sources.php = ['omni']
    " let g:deoplete#ignore_sources.php = ['phpcd', 'omni'] " will disable phpcd from deoplete
endif
" }}}

" php.vim {{{
" I have most of this turned off because built-in doxygen support is more
" comprehensive. I have it enabled in my main .vimrc. :h doxygen
" let g:php_var_selector_is_identifier = 1
" function! PhpSyntaxOverride() abort
"     " docblock color
"     hi! link phpDocTags phpDefine
"     " docblock comments italic
"     hi! PreProc cterm=italic
"     hi! link phpDocTags phpDefine
"     hi! link phpDocParam phpType
"     hi! link phpDocParam phpRegion
"     hi! link phpDocIdentifier phpIdentifier
"     " Colorize namespace separator in use, extends and implements
"     hi! link phpUseNamespaceSeparator Comment
"     hi! link phpClassNamespaceSeparator Comment
" endfunction
" if has_key(g:plugs, 'php.vim')
"     " highlight docblocks
"     augroup phpdoctagsgroup
"         autocmd!
"         autocmd FileType php call PhpSyntaxOverride()
"     augroup END
" endif
" }}}

" phpactor {{{
" current phpenv version of php
let g:phpactorPhpBin = $HOME . "/.asdf/installs/php/7.4.7/bin/php"
if has_key(g:plugs, 'phpactor')

    function! PHPModify(transformer) abort
        :update
        let l:cmd = "silent !" . g:phpactorPhpBin . " " . $HOME . "/.vim/plugged/phpactor/bin/phpactor class:transform " . expand('%') . ' --transform='.a:transformer
        execute l:cmd
    endfunction

    function! PHPConstructorArgumentMagic()
        " update phpdoc
        if exists("*UpdatePhpDocIfExists")
            normal! gg
            /__construct
            normal! n
            :call UpdatePhpDocIfExists()
            :w
        endif
        :call PHPModify("complete_constructor")
    endfunction

    function! PHPFixEverything()
        call PHPConstructorArgumentMagic()
        call PHPModify("implement_contracts")
        call PHPModify("fix_namespace_class_name")
        call PHPModify("add_missing_properties")
        :PhpactorImportMissingClasses
    endfunction

    function! PHPMoveDir() abort
        :w
        let l:oldPath = input("Old path: ", expand('%:p:h'))
        let l:newPath = input("New path: ", l:oldPath)
        let l:cmd = "silent !" . g:phpactorPhpBin . " " . $HOME . "/.vim/plugged/phpactor/bin/phpactor class:move " . l:oldPath . ' ' . l:newPath
        execute l:cmd
    endfunction

    " NOTE: to see available refactor mappings: <leader>?
    augroup phpactor_mappings
        autocmd!
        au FileType php nnoremap <buffer> <Leader>rsm :PhpactorContextMenu<CR>
        au FileType php nnoremap <buffer> <Leader>rcv :PhpactorChangeVisibility<CR>
        au FileType php nnoremap <buffer> ]v :PhpactorChangeVisibility<CR>
        au FileType php nnoremap <buffer> <leader>rcf :call PHPFixEverything()<cr>
        au FileType php nnoremap <buffer> <leader>raa :call PHPModify("add_missing_properties")<cr>
        au fileType php nnoremap <buffer> <leader>ric :call PHPModify("implement_contracts")<cr>

        au FileType php nnoremap <buffer> <Leader>rrc :PhpactorMoveFile<CR>
        au FileType php nnoremap <buffer> <leader>rrd :call PHPMoveDir()<cr>
        au FileType php nnoremap <buffer> <Leader>rcc :PhpactorCopyFile<CR>
        " this could be better but just hover over the method name and press
        " (r) for replace references. Otherwise I have to write a lot more
        " code to skip one keypress.
        au FileType php nnoremap <buffer> <Leader>rrm :PhpactorContextMenu<CR>

        au FileType php vnoremap <buffer> <Leader>rem :'< ,'>PhpactorExtractMethod<CR>
        au FileType php vnoremap <buffer> <Leader>rev :'< ,'>PhpactorExtractExpression<CR>
        au FileType php nnoremap <buffer> <Leader>rev :PhpactorExtractExpression<CR>
        au FileType php nnoremap <buffer> <Leader>rei :PhpactorClassInflect<CR>
    augroup END

endif
" }}}

" phpcomplete {{{
if has_key(g:plugs, 'phpcomplete.vim')
    augroup mycompletephp
        autocmd!
        autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    augroup END
endif
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

" quickpeek.vim {{{
" if isdirectory(expand("~/.vim/plugged/quickpeek.vim"))
"     nnoremap <c-p> :QuickpeekToggle<cr>
" endif
" }}}

" RootIgnore.vim {{{
let g:RootIgnoreAgignore=1
let g:RootIgnoreUseHome=1
" }}}

" snipbar {{{
if isdirectory(expand("~/.vim/plugged/snipbar"))
    nnoremap <leader>ss :SnipBar<CR>
endif
" }}}

" {{{ tagbar
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_previewwin_pos = "botright"
" let g:tagbar_autopreview = 1
" let g:tagbar_hide_nonpublic=1 " hide non-public methods. Now tagbar looks more like an interface!
" let g:tagbar_left = 1
" tagbar autofocus is the whole point of tagbar
if has_key(g:plugs, 'tagbar') | nnoremap <silent> <leader>bb :TagbarToggle<CR> | endif
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

" tmux-complete.vim {{{
if has_key(g:plugs, 'asyncomplete.vim') && has_key(g:plugs, 'tmux-complete.vim')
    let g:tmuxcomplete#asyncomplete_source_options = {
                \ 'name': 'tmuxcomplete',
                \ 'whitelist': ['*'],
                \ 'config': {
                \     'splitmode': 'words',
                \     'filter_prefix': 1,
                \     'show_incomplete': 1,
                \     'sort_candidates': 0,
                \     'scrollback': 0,
                \     'truncate': 0
                \     }
                \ }
endif
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
" x: UTC
" y: battery, docker machine status, haproxy status, socks proxy status
" z: date/time info
" \ 'b': ['#h'],
" \ 'options': {'status-justify': 'center'},
"
" I would like to use 'b' and 'c' but I found 'b' is actually lighter than
" 'y', so it's insonsistent with the other side. And they won't provide a 'd'.
" At least both on 'c' looks better than splitting between 'b' and 'c'.
let g:tmuxline_preset = {
    \ 'a': ['🏠 #S'],
    \ 'c': [
        \ "🔋 #(pmset -g batt | egrep '\d+%' | awk '{print $3}' | awk -F';' '{print $1}')",
        \ '#(~/.bin/saatchi-haproxy-status.sh)'
    \ ],
    \ 'win': ['#I', '#W'],
    \ 'cwin': ['#I', '#W#F'],
    \ 'x': [
        \ "#(TZ=Etc/UTC date '+%%R UTC')"
    \ ],
    \ 'y': ['%l:%M %p'],
    \ 'z': ['%a', '%b %d']
\}
" disabled:
"
" this is just distracting
" \ '#{prefix_text} #{synchronized_text} #{sharedsession_text}',
"
" \ '🚢  #(kubectl config current-context)',
"
" don't use: anchor, sailboat
" other possible emojis to use:
" ❏
" 📦
" 🏭
" ⎈
" ☸️
" 🕸️
" ⚙️
" these just take up a lot of space when I know the context already
" 🕗
" 🕑
" 📅

" TODO
" let g:tmuxline_theme = tmuxline#api#set_theme({
" 			\ 'a': ['237', '109', 'bold'],
" 			\ 'b': ['109', '236', ''],
" 			\ 'c': ['240', '237', ''],
" 			\ 'bg': ['240', '237', ''],
" 			\ 'cwin': ['109', '236', ''],
" 			\ 'win': ['240', '237', ''],
" 			\ 'x': ['240', '237', ''],
" 			\ 'y': ['109', '236', ''],
" 			\ 'z': ['237', '109', ''],
" 			\ })
let g:airline#extensions#tmuxline#snapshot_file = '~/.tmuxline.conf'

if has_key(g:plugs, 'tmuxline.vim')
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

" NOTE: do not mess with this config value, you are going to have a bad time.
let g:UltiSnipsSnippetDirectories=['UltiSnips', $HOME.'/.config/nvim/UltiSnips']

" If you're on native vim, just use this instead of :UltiSnipsEdit. Trust me,
" I've spent way too much time on this.
" command! EditUltiSnips exec ":vsp ".$HOME."/.config/nvim/UltiSnips/".&filetype.".snippets"

" UltiSnips somehow forgets this mapping when I open a new file :/
if has_key(g:plugs, 'ultisnips')
    inoremap <c-j> <c-r>=UltiSnips#JumpForwards()<CR>
endif

" }}}

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
" REMINDER: <leader>ev lets you evaluate the visual selection!
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
let g:vdebug_options['simplified_status'] = 1
" let g:vdebug_options["break_on_open"] = 0 " (default = 1)

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

" maximize vertically either the watch window or the stack trace window on
" enter. VDebug is nearly unusable for monitoring state without this because
" the damn watch window is so small! It's tedious to maximize it manually.
augroup vdebugwatchpanellarger
    autocmd!
    " to start with make the debugger watch window max height
    " autocmd Syntax debugger_watch resize 999
    " autocmd Filetype debugger_watch resize 999
    " if I navigate into the stack or the watch, resize that window to max
    " height
    autocmd BufEnter DebuggerWatch resize 999
    autocmd BufEnter DebuggerStack resize 999
augroup END

" didn't work as just a command
if exists(":VdebugEval")
    function! ZendRoutingParams() abort
        :VdebugEval $this->getRequest()->getParams()
    endfunction
    command! ZendRoutingParams :call ZendRoutingParams()
endif

if has_key(g:plugs, 'vdebug') && has_key(g:plugs, 'Repeatable.vim')
    " expand or collapse context trees
    function! OpenVdebugTrees() abort
        :silent! exe 'g/'.g:vdebug_options["marker_closed_tree"]."/normal \<cr><cr>"
    endfunction
    function! CloseVdebugTrees() abort
        :silent! exe 'g/'.g:vdebug_options["marker_open_tree"]."/normal \<cr><cr>"
    endfunction
    if exists(":Repeatable")
        Repeatable nnoremap <leader>v+ :silent! call OpenVdebugTrees()<cr>
        Repeatable nnoremap <leader>v- :silent! call CloseVdebugTrees()<cr>
    endif
endif
" }}}

" vim-agriculture {{{
if has_key(g:plugs, 'vim-agriculture')
    " this is EXACTLY what I wanted. Search with raw ag args but allow
    " filtering down with fzf. No quickfix problems with neovim. Perfect.
    nnoremap <leader>gg :AgRaw<space>
    " nnoremap <leader>gg <Plug>AgRawSearch
    " these don't open a fzf window for some reason
    vnoremap <leader>gv <Plug>AgRawVisualSelection
    nnoremap <leader>g* <Plug>AgRawWordUnderCursor
endif
" }}}

" {{{ vim-airline
" let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1 " airline use cool powerline symbols (this also makes vista.vim use powerline symbols)
let g:airline#extensions#whitespace#enabled = 1 " show whitespace warnings
let g:airline_highlighting_cache = 1 " cache syntax highlighting for better performance

" tabline
let g:airline#extensions#tabline#enabled = 1 " advanced tabline
let g:airline#extensions#tabline#close_symbol = '✕' " configure symbol used to represent close button
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_count = 0 " hide tab count on right
" let g:airline#extensions#tabline#exclude_preview = 0
let g:airline#extensions#tabline#show_buffers = 0 " shows buffers when no tabs
let g:airline#extensions#tabline#show_splits = 1 " shows how many splits are in each tab and which split you're on
let g:airline#extensions#tabline#show_tab_type = 0 " right side says either 'buffers' or 'tabs'
let g:airline#extensions#tagbar#enabled = 0 " cool but slows down php

" emacs-like slanted separators
" let g:airline_left_sep="\ue0b8"
" let g:airline_left_alt_sep = "\ue0b9"
" let g:airline_right_sep="\ue0be"
" let g:airline_right_alt_sep="\ue0b9"

" vim-obsession indicator - show current session name {{{
" e.g. '$ my-session-name.vim'
let g:this_session = get(g:, 'this_session', '')
let g:current_session_text = ''

" cache current session text
function! GetCurrentSessionText() abort
    if g:current_session_text !=# ''
        return g:current_session_text
    endif
    let g:current_session_text = '$ ' . fnamemodify(g:this_session, ':t')
    return g:current_session_text
endfunction

" after the obsession session loads, set the airline obsession text
augroup obsession_current
    autocmd!
    autocmd SessionLoadPost * let g:airline#extensions#obsession#indicator_text = GetCurrentSessionText()
augroup end
" }}}

if has_key(g:plugs, 'vim-airline')
    " add asyncrun status for async tasks e.g. 'running' 'failure' 'success'
    if has_key(g:plugs, 'asyncrun.vim')
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

" vim-closer {{{
augroup phpvimclosergroup
    autocmd!
    autocmd FileType php
                \ let b:closer = 1 |
                " ; will add a ; after if closing bracket e.g. `if (true) {\n};`
                " \ let b:closer_flags = '([{;' |
                \ let b:closer_flags = '([{' |
                \ let b:closer_no_semi = '^\s*\(function\|class\|if\|else\)' |
                \ let b:closer_semi_ctx = ')\s*{$'
augroup END
" }}}

" vim-colorscheme-switcher {{{
let g:colorscheme_switcher_exclude_builtins = 1
" only because shift-F8 is already mapped
let g:colorscheme_switcher_define_mappings = 0
if has_key(g:plugs, 'vim-colorscheme-switcher')
    nnoremap <F7> :PrevColorScheme<cr>
    nnoremap <F8> :NextColorScheme<cr>
endif
" }}}

" vim-commentary {{{
augroup vimcommentarycommentstring
    autocmd!
    autocmd FileType php setlocal commentstring=//\ %s
    autocmd FileType haproxy setlocal commentstring=#\ %s
    autocmd FileType neon setlocal commentstring=#\ %s
    autocmd FileType gitconfig setlocal commentstring=#\ %s
    autocmd BufRead,BufNewFile .myclirc setlocal commentstring=#\ %s
    autocmd BufRead,BufNewFile .my.cnf setlocal commentstring=#\ %s
    autocmd FileType plantuml setlocal commentstring='\ %s
    autocmd BufRead,BufNewFile .env setlocal commentstring=#\ %s
augroup END
if has_key(g:plugs, 'vim-commentary')
    " this is for my muscle memory from nerd-commenter, but try to get used to
    " gcc or gc(motion) instead (like gcap)
    nnoremap <leader>c<space> :Commentary<cr>
    vnoremap <leader>c<space> :Commentary<cr>
endif
" }}}

" vim-devicons {{{
" this takes up too much horizontal space
let g:webdevicons_enable_airline_tabline = 0
" }}}

" vim-dispatch {{{
" let g:dispatch_no_tmux_make = 1  " Prefer job strategy even in tmux.
" }}}

" vim-doge {{{
let g:doge_mapping="<leader>dd"
" }}}

" vim-edgemotion {{{
" if has_key(g:plugs, 'vim-edgemotion')
"     " had trouble with nnoremap :/
"     map <C-j> <Plug>(edgemotion-j)
"     map <C-k> <Plug>(edgemotion-k)
" endif
" }}}

" vim-fix-my-js {{{
let g:fixmyjs_use_local = 1
if has_key(g:plugs, 'vim-fix-my-js') | noremap <Leader>jf :Fixmyjs<CR> | endif
" }}}

" vim-flow {{{
let g:flow#enable = 0 " disable flow linting - ale handles that
let g:flow#omnifunc = 1
let g:flow#timeout = 4 " increase timeout to avoid errors on init
" }}}

" vim-fugivite {{{
" cd to git root: :Gcd
let g:fugitive_git_executable = 'git -c "color.ui=never"' " Why is this not default?
" I don't use these but keeping them around in case I ever switch from tig to
" fugitive
" if has_key(g:plugs, 'vim-fugitive')
"     nnoremap <leader>gpl :Gpull<cr>
"     nnoremap <leader>gps :Gpush<cr>
"     nnoremap <leader>gs :Gstatus<cr>
"     nnoremap <leader>gw :Gwrite<cr>
"     nnoremap <leader>gr :Gread<cr>
"     nnoremap <leader>gbl :Gblame<cr>
"     nnoremap <leader>gbr :Gbrowse<cr>
"     nnoremap <leader>gl :Glog<cr>
"     nnoremap <leader>gm :Gmove<space>
"     nnoremap <leader>gco :Git co<space>
"     nnoremap <leader>go :Git open<space>
"     nnoremap <leader>ge :Gedit<cr>
"     nnoremap <Leader>g- :Git stash<CR>:e<CR>
"     nnoremap <Leader>g+ :Git stash apply<CR>:e<CR>
"     " nnoremap <leader>gc :!git add -A<cr> :Gcommit<cr>
"     nnoremap <leader>gc :Gcommit<cr>
"     command! WorkingCommit :!git add -A && git commit -m 'working'<cr>
" endif
" }}}

" vim-http-client {{{
let g:http_client_bind_hotkey = 0 " (default 1)
let g:http_client_focus_output_window = 0
" if isdirectory(expand("~/.vim/plugged/vim-http-client"))
"     nnoremap <leader>pp :HTTPClientDoRequest<cr>
" endif
" }}}

" vim-git {{{
if has_key(g:plugs, 'vim-git')
    augroup vimgitautocmd
        autocmd!
        " NOTE: these work on multiple lines at once! (a range)
        autocmd FileType gitrebase noremap <buffer> <silent> I :Pick<CR>
        autocmd FileType gitrebase noremap <buffer> <silent> R :Reword<CR>
        autocmd FileType gitrebase noremap <buffer> <silent> E :Edit<CR>
        " autocmd FileType gitrebase noremap <buffer> <silent> S :Squash<CR>
        autocmd FileType gitrebase noremap <buffer> <silent> F :Fixup<CR>
        autocmd FileType gitrebase noremap <buffer> <silent> D :Drop<CR>
    augroup END
endif
" }}}

" vim-gitgutter {{{
" let g:gitgutter_sign_column_always = 1
let g:gitgutter_realtime = 0 | let g:gitgutter_eager = 0 " trade accuracy for speed. Only on save.
" }}}

" gitsessions.vim {{{
if isdirectory(expand("~/.vim/plugged/gitsessions.vim"))
    nnoremap <leader>ss :GitSessionSave<cr>
    nnoremap <leader>sl :GitSessionLoad<cr>
    nnoremap <leader>sd :GitSessionDelete<cr>
endif
" let g:gitsessions_dir = $PWD . '/sessions'
let g:gitsessions_disable_auto_load = 1
" }}}

" vim-ghost {{{
let g:ghost_darwin_app="iTerm2"
if has_key(g:plugs, 'vim-ghost')
    nnoremap <leader>g+ :GhostStart<cr>
    nnoremap <leader>g- :GhostStop<cr>
endif
" }}}

" vim-gutentags {{{
" if isdirectory(expand("~/.vim/plugged/vim-gutentags"))
"     nnoremap <leader>gu :execute 'GutentagsUpdate!'<cr>:redraw!<cr>
" else
"     nnoremap <leader>gu :AsyncRun ctags -R .<cr>
" endif
" let g:gutentags_ctags_executable_php = '( git ls-files --ignored --exclude-standard | ctags --links=no -L- )'
" let g:gutentags_ctags_executable_php = '( ag -l | ctags --links=no -L- )'

let g:gutentags_ctags_executable_ruby = 'ripper-tags -R --ignore-unsupported-options'

" guess the project type based on these files. More will be added later
" automatically by gutentags.
let g:gutentags_project_info = [{'type': 'php', 'file': 'composer.json'}]

" I pass gitignore to wildignore with another plugin. This defaults to 1, so
" if I left it in the default, gutentags would not tag any vendor files :/
let g:gutentags_ctags_exclude_wildignore = 0

" A List of file types that Gutentags should ignore. When a buffer is opened,
" if its 'filetype' is found in this list, Gutentags features won't be
" available for this buffer. (used to disable ctags on save)
let g:gutentags_exclude_filetypes = ['gitcommit']

" Some debugging/troubleshooting commands are also available if the
" |gutentags_define_advanced_commands| global setting is set to 1.
" let g:gutentags_define_advanced_commands = 1 | let g:gutentags_trace=1

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

let g:gutentags_modules = ['ctags']
" Commented out - I added this manually in .vimrc for php projects instead
" if executable('cscope') && has('cscope')
"     call add(g:gutentags_modules, 'cscope')
"     " set cscopetag " this is set in ~/.vimrc
" endif

" disable gutentags for some cases
augroup gitnogutentags
    autocmd!
    autocmd FileType gitrebase let g:gutentags_modules = []
    autocmd FileType gitcommit let g:gutentags_modules = []
    autocmd FileType git let g:gutentags_modules = []
augroup END
if &diff
    let g:gutentags_modules = []
endif

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

" tells cscope to only index php files
" let g:gutentags_file_list_command = 'find . -type f -name *.php'
"
" tells cscope to respect the same exclude settings in ~/.ctags
" NOTE: this applies to all gutentags modules, not just cscope! As such it
" ignores files in .ignore, which broke _ide_helper.php integration. In the
" end I just turned off cscope... it's not that helpful in php. Grepping for
" usage is faster and more accurate.
let g:gutentags_file_list_command = $HOME.'/.support/cscope_find.sh'
"
" lets cscope ignore files in gitignore
" let g:gutentags_file_list_command = {
"     \ 'markers': {
"         \ '.git': 'git ls-files',
"         \ },
"     \ }
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
" variations on indent guide character
let g:indentLine_char = '┊'
" let g:indentLine_char = '┆'
" let g:indentLine_char = '¦'
" let g:indentLine_char = '│'
" let g:indentLine_char = '⎸'
" let g:indentLine_char = '▏'
" let g:indentLine_char = '│'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊'] " each level has a distinct character

" TODO figure out how to enable list for just yaml

let g:indentLine_faster = 1
let g:indentLine_fileTypeExclude = [
    \ 'fzf',
    \ 'help',
    \ 'startify',
    \ 'markdown'
\ ]

" ensure json shows quotes
let g:vim_json_syntax_conceal = 0

let s:indentline_is_uniform = 1
function! IndentLinesStaggered() abort
    let g:indentLine_char = ''
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    IndentLinesDisable
    IndentLinesEnable
    let s:indentline_is_uniform = 0
endfunction

function! IndentLinesUniform() abort
    let g:indentLine_char = '┊'
    let g:indentLine_char_list = []
    IndentLinesDisable
    IndentLinesEnable
    let s:indentline_is_uniform = 1
endfunction

function! IndentLinesToggleSymbols() abort
    if s:indentline_is_uniform
        call IndentLinesStaggered()
    else
        call IndentLinesUniform()
    endif
endfunction

if has_key(g:plugs, 'indentLine')
    nnoremap <leader>ii :call IndentLinesToggleSymbols()<CR>
endif

" if you want to see dots for all leading spaces
" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_leadingSpaceChar = '·'
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
if has_key(g:plugs, 'vim-lotr') | nnoremap <leader>ll :LOTRToggle<cr> | endif
" }}}

" vim-lsc {{{
let g:lsc_server_commands = {
\     'php': {
\         'command': '~/.bin/php-language-server',
\         'log_level': 1,
\         'suppress_stderr': v:true
\     }
\ }
" \         'command': '/usr/local/bin/intelephense --stdio',
let g:lsc_auto_map = {
\     'Completion': 'omnifunc',
\     'ShowHover': 'K'
\ }
" }}}

" vim-lsp {{{
if has_key(g:plugs, 'vim-lsp') && has('autocmd') && exists('+omnifunc')
    " This all happens automatically with vim-lsp-settings package
    "
    " augroup lsp_group
    "     autocmd!

    "     " php-language-server.php version
    "     " I hate php-language-server. It sucks.
    "     autocmd User lsp_setup call lsp#register_server({
    "         \ 'name': 'php-language-server',
    "         \ 'cmd': {server_info->[&shell, &shellcmdflag, $HOME.'/.bin/php-language-server']},
    "         \ 'whitelist': ['php'],
    "     \ })
    "     " \ 'cmd': {server_info->[&shell, &shellcmdflag, $HOME.'/.bin/php-language-server']},

    "     " intelephense version (php language server written in node)
    "     " autocmd User lsp_setup call lsp#register_server({
    "     "     \ 'name': 'intelephense',
    "     "     \ 'cmd': {server_info->[&shell, &shellcmdflag, $HOME.'/.bin/intelephense-server']},
    "     "     \ 'whitelist': ['php'],
    "     " \ })
    " augroup END

    augroup lsp_group
        autocmd!
        " TODO get js working - problem with yarn flow
        autocmd FileType php setlocal omnifunc=lsp#complete
    augroup END

    " from vim-lsp wiki https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Flow
    " if executable('flow')
    "     au User lsp_setup call lsp#register_server({
    "         \ 'name': 'flow',
    "         \ 'cmd': {server_info->['flow', 'lsp', '--from', 'vim-lsp']},
    "         \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
    "         \ 'whitelist': ['javascript', 'javascript.jsx'],
    "         \ })
    " endif

endif

" this is handled by ALE
let g:lsp_diagnostics_enabled = 0

" having trouble?
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
" }}}

" vim-markbar {{{
if has_key(g:plugs, 'vim-markbar')
    " tried nnoremap but didn't work for some reason :/
    nmap <leader>mm <Plug>ToggleMarkbar
    augroup markbar-grp
        autocmd!
        autocmd FileType markbar nnoremap q :q<cr>
    augroup END
endif
" }}}

" vim-markdown {{{
" built-in markdown plugin settings
" https://github.com/tpope/vim-markdown
let g:markdown_folding=1
let g:markdown_syntax_conceal=0
let g:markdown_minlines=100

" https://old.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/
let g:markdown_fenced_languages = [
    \ 'sh',
    \ 'css',
    \ 'javascript=javascript.jsx',
    \ 'js=javascript.jsx',
    \ 'json=javascript',
    \ 'php',
    \ 'ruby',
    \ 'scss',
    \ 'sql',
    \ 'xml',
    \ 'html'
\ ]
" }}}

" vim-markdown-folding {{{
let g:markdown_fold_style='nested'
" }}}

" vim-matchup {{{
let g:matchup_matchparen_status_offscreen = 0
" }}}

" vim-monokai-tasty {{{
let g:vim_monokai_tasty_italic = 1
" }}}

" vim-mundo {{{
let g:mundo_close_on_revert = 1
if has_key(g:plugs, 'vim-mundo')
    silent! unmap <leader>u
    " toggle undotree window
    nnoremap <leader>uu :MundoToggle<CR>
endif
" }}}

" vim-notes {{{
let g:notes_directories = ['~/notes']
" }}}

" vim-pasta {{{
let g:pasta_disabled_filetypes = ['netrw', 'nerdtree']
" }}}

" vim-phpfmt {{{
let g:phpfmt_autosave = 0 " default: 1 autoformats with phpcbf on save
if has_key(g:plugs, 'vim-phpfmt')
    command! FormatPhp PhpFmt
endif
" }}}

" {{{ vim-php-namespace
let g:php_namespace_sort_after_insert = 1 " auto sort use after inserting use statement
if has_key(g:plugs, 'vim-php-namespace')

    function! PhpExpandClassWithRootNamespace()
        let restorepos = line(".") . "normal!" . virtcol(".") . "|"
        " move to last element
        call search('\%#[[:alnum:]\\_]\+', 'cW')
        " move to first char of last element
        call search('[[:alnum:]_]\+', 'bcW')
        let cur_class = expand("<cword>")
        let fqn = PhpFindFqn(cur_class)
        if fqn is 0
            return
        endif
        let pfqn = "\\" . fqn[1]
        substitute /\%#[[:alnum:]\\_]\+/\=pfqn/
        exe restorepos
        " move cursor after fqn
        call search('\([[:blank:]]*[[:alnum:]\\_]\)*', 'ceW')
    endfunction

    " php add use statement for current class
    augroup phpnamespacegroup
        autocmd!
        autocmd FileType php inoremap <Leader><Leader>u <C-O>:call PhpInsertUse()<CR>
        autocmd FileType php nnoremap <Leader><Leader>u :call PhpInsertUse()<CR>
        " expand the namespace for the current class name with \ before
        autocmd FileType php inoremap <Leader><Leader>e <C-O>:call PhpExpandClassWithRootNamespace()<CR>
        autocmd FileType php nnoremap <Leader><Leader>e :call PhpExpandClassWithRootNamespace()<CR>
        " expand the namespace for the current class name without \ before
        autocmd FileType php inoremap <Leader><Leader>x <C-O>:call PhpExpandClass()<CR>
        autocmd FileType php nnoremap <Leader><Leader>x :call PhpExpandClass()<CR>
    augroup END
endif
" }}}

" vim-phpqa {{{
let g:phpqa_messdetector_autorun = 0 "default: 1
let g:phpqa_codesniffer_autorun = 0 "default: 1
let g:phpqa_codecoverage_autorun = 0 "default: 1
let g:phpqa_open_loc = 0 "default: 1
let g:phpqa_codecoverage_file = 'coverage/clover.xml'
" }}}

" vim-plug {{{
" Install any newly added plugins in ~/.vimrc.plugins
if exists(':PlugInstall') | nnoremap <leader>bi :Source<cr> :PlugInstall<cr> :UpdateRemotePlugins<cr> | endif
" Remove any newly removed plugins in ~/.vimrc.plugins
if exists(':PlugClean') | nnoremap <leader>bc :Source<cr> :PlugClean!<cr> | endif
" Upgrade all installed plugins in ~/.vimrc.plugins
if exists(':PlugUpdate') | nnoremap <leader>bu :Source<cr> :silent! :UpdateRemotePlugins<cr> :PlugUpdate<cr> :PlugUpgrade<cr> | endif
" }}}

" vim-polyglot {{{
let g:polyglot_disabled=['php'] " I use a different php syntax plugin
" }}}

" vim-rest-console {{{
" aka vim-rest-client
"
" TODO make some shortcuts to login and get a session cookie and to retrieve
" an access token.
"
" let g:vrc_show_command = 1 " display the actual curl command being run when firing http requests
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
" if has_key(g:plugs, 'vim-rest-console')
"     command! RestJson let b:vrc_response_default_content_type = 'application/json'
"     command! RestXml let g:vrc_response_default_content_type = 'text/xml'
" endif

" fix a problem where vrc buffers lose syntax sync setting, causing the buffer
" to lose syntax highlighting on scroll
augroup vrc_syntax_fix
    autocmd!
    " you would think this would work but it doesn't for some reason
    " autocmd BufRead,BufNewFile __REST_response__ syntax sync minlines=200
    autocmd WinEnter __REST_response__ syntax sync minlines=200
augroup END

" let g:vrc_auto_format_response_enabled = 1 " enabled by default
" let g:vrc_split_request_body = 1 " allow each line to be key=value after GET /my/url. NOTE: this breaks PUT requests with bodies!
" let g:vrc_cookie_jar = '/tmp/vrc_cookie_jar'

" }}}

" vim-php-refactoring-toolbox {{{
" http://kushellig.de/neovim-php-ide/#write-less-messy-code-with-neomake
let g:vim_php_refactoring_use_default_mapping = 0
let g:vim_php_refactoring_default_property_visibility = 'private'
let g:vim_php_refactoring_default_method_visibility = 'private'
let g:vim_php_refactoring_auto_validate_visibility = 1
let g:vim_php_refactoring_phpdoc = "pdv#DocumentCurrentLine"

if has_key(g:plugs, 'vim-php-refactoring-toolbox')
    " NOTE: to see available refactor mappings: <leader>?
    augroup vim_php_refactoring_toolbox_mappings
        autocmd!
        autocmd FileType php nnoremap <Leader>rrv :call PhpRenameLocalVariable()<CR>
        autocmd FileType php nnoremap <Leader>rrp :call PhpRenameClassVariable()<CR>
        " autocmd FileType php nnoremap <Leader>rcm :call PhpRenameMethod()<CR>
        "
        " this is useful to expand to FQCN, then extract _as_ a given different name, then sort use statements
        autocmd FileType php nnoremap <Leader>reu :call PhpExtractUse()<CR>
        autocmd FileType php vnoremap <Leader>rec :call PhpExtractConst()<CR>
        autocmd FileType php nnoremap <Leader>rep :call PhpExtractClassProperty()<CR>
        autocmd FileType php vnoremap <Leader>rem :call PhpExtractMethod()<CR>
        " autocmd FileType php nnoremap <Leader>rcp :call PhpCreateProperty()<CR>
        " autocmd FileType php nnoremap <Leader>rdu :call PhpDetectUnusedUseStatements()<CR>
        " autocmd FileType php vnoremap <Leader>== :call PhpAlignAssigns()<CR>
        " autocmd FileType php nnoremap <Leader>sg :call PhpCreateSettersAndGetters()<CR>
        " autocmd FileType php nnoremap <Leader>cog :call PhpCreateGetters()<CR>
        " autocmd FileType php nnoremap <Leader>da :call PhpDocAll()<CR>
    augroup END
endif
" }}}

" vim-slash {{{
if has_key(g:plugs, 'vim-slash') && has_key(g:plugs, 'vim-indexed-search')
    let g:indexed_search_mappings = 0
    noremap <Plug>(slash-after) :ShowSearchIndex<CR>
endif
" }}}

" vim-startify {{{
if (has('nvim'))
    " let g:ascii = [
    "     \ '                             _',
    "     \ '      ____  ___  ____ _   __(_)___ ___',
    "     \ '     / __ \/ _ \/ __ \ | / / / __ `__ \',
    "     \ '    / / / /  __/ /_/ / |/ / / / / / / /',
    "     \ '   /_/ /_/\___/\____/|___/_/_/ /_/ /_/',
    "     \ '',
    "     \ '',
    "     \ ]
    " let g:startify_custom_header = g:ascii + startify#fortune#boxed()
    " let g:startify_custom_header = g:ascii + startify#fortune#cowsay('', '═','║','╔','╗','╝','╚')
    " let g:startify_custom_header = g:ascii + startify#fortune#quote()

else
    " let g:startify_custom_header = [
    "     \ '                                  __         __',
    "     \ '            __                  /''_ `\     /''__`\',
    "     \ '    __  __ /\_\    ___ ___     /\ \L\ \   /\ \/\ \',
    "     \ '   /\ \/\ \\/\ \ /'' __` __`\   \/_> _ <_  \ \ \ \ \',
    "     \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \    /\ \L\ \__\ \ \_\ \',
    "     \ '    \ \___/  \ \_\ \_\ \_\ \_\   \ \____/\_\\ \____/',
    "     \ '     \/__/    \/_/\/_/\/_/\/_/    \/___/\/_/ \/___/',
    "     \ '',
    "     \ '',
    "     \ ]

endif

" New quote every time. Indented 3 spaces.
let g:ascii = []
let g:startify_custom_header =
            \ 'map(g:ascii + startify#fortune#boxed(), "\"   \".v:val")'

" a list if files to always bookmark. Will be shown at bottom
" of the startify screen.
let g:startify_bookmarks = [ '~/.vimrc', '~/.vimrc.plugins' ]
" let g:startify_change_to_vcs_root = 1 " always cd to git root on startup

" show empty buffer and quit
let g:startify_enable_special = 0
" speeds up startify but sacrifices some accuracy
let g:startify_enable_unsafe = 1
" sort descending by last used
let g:startify_session_sort = 1
" disable common but unimportant files
let g:startify_skiplist = [ 'COMMIT_EDITMSG', '\.DS_Store' ]
let g:startify_files_number = 9 " recently used
" below disabled because I now use vim-obsession
" let g:startify_session_autoload = 1 " autoload Session.vim in the current dir
let g:startify_session_persistence = 0 " auto save session on exit like obsession
" save/load sessions from the current dir
" let g:startify_session_dir = getcwd().'/sessions'
" gitsessions dir... but actually it's a pretty good idea to use even outside
" of gitsessions.
let g:startify_session_dir = expand('~/.vim/sessions' . getcwd())

" reorder and whitelist certain groups
let g:startify_lists = [
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]
" \ { 'type': 'files',     'header': ['   MRU']            },
" \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },

" commented out because I'm trying out gitsessions.vim instead
" if has_key(g:plugs, 'vim-startify')
"     " TODO integrate this to automatically :Obsess somehow...
"     nnoremap <leader>ss :SSave<cr>
"     nnoremap <leader>sl :SLoad<cr>
"     nnoremap <leader>sd :SDelete<cr>
" endif

" this feature should not even exist. It is stupid.
let g:startify_change_to_dir = 0

" this makes my sessions all start in empty tabs :(
" function StartifyOnNewTab() abort
"     if !exists('t:startify_new_tab')
"                 \ && empty(expand('%'))
"                 \ && empty(&l:buftype)
"                 \ && &l:modifiable
"         let t:startify_new_tab = 1
"         Startify
"     endif
" endfunction

" if has('nvim')
"   autocmd TabNewEntered * Startify
" else
"   autocmd BufWinEnter * call StartifyOnNewTab()
" endif
" }}}"

" vim-taskwarrior {{{
let g:task_highlight_field = 0
" }}}

" vim-tbone {{{
if has_key(g:plugs, 'vim-tbone')
    " highlight text and g> to send text to bottom right split. Useful for sql window.
    nnoremap g> <ESC>vap:Twrite bottom-right<CR>
    xnoremap g> :Twrite bottom-right<CR>
endif
" }}}

" vim-test {{{
" let test#php#phpunit#options = '--testdox'
" let test#php#phpunit#options = '--colors=never'
" if isdirectory(expand("~/.vim/plugged/asyncrun.vim")) | let test#strategy = 'asyncrun' | endif
if has_key(g:plugs, 'vimux') | let g:test#strategy = 'vimux' | endif
if has_key(g:plugs, 'vim-test')
    nnoremap <silent> <leader>tn :TestNearest<CR>
    nnoremap <silent> <leader>tf :TestFile<CR>
    nnoremap <silent> <leader>ts :TestSuite<CR>
    " nnoremap <silent> <leader>tl :TestLast<CR>
    " nnoremap <silent> <leader>tv :TestVisit<CR>
endif
" }}}

" VimCompletesMe {{{
let g:vcm_direction = 'p'
let g:vcm_s_tab_behavior = 1
" }}}

" vimux {{{
let g:VimuxHeight = '40'
if has_key(g:plugs, 'vimux')
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
    nnoremap <leader>pw :call VimuxRunCommand("clear; puw " . bufname("%"))<CR>
    nnoremap <leader>pf :call VimuxRunCommand("clear; puw --filter=" . <c-r><c-w>."")<CR>
    nnoremap <leader>sw :call VimuxRunCommand("clear; psw " . bufname("%"))<CR>
    nnoremap <leader>sl :call VimuxRunCommand("clear; psw " . bufname("%") . ":" . (line(".") + 1))<CR>
endif
" }}}

" vimwiki {{{
" <Leader>ww opens the first wiki from |g:vimwiki_list|.
" [count]<Leader>wt or <Plug>VimwikiTabIndex
" <Leader>ws or <Plug>VimwikiUISelect
" [count]<Leader>wi or <Plug>VimwikiDiaryIndex Open diary index file of the [count]'s wiki.
" [count]<Leader>w<Leader>w or <Plug>VimwikiMakeDiaryNote Open diary wiki-file for today of the [count]'s wiki.
let g:vimwiki_list = [{'path': '~/.private-stuff/notes/', 'syntax': 'markdown', 'ext': '.md'}]
if has_key(g:plugs, 'vimwiki')
    command! Note :e ~/.private-stuff/notes/saatchiart/
endif
let g:vimwiki_folding = 'expr'
let g:vimwiki_ext2syntax = { '.md': 'markdown' }
" }}}

" vista.vim {{{
let g:vista_close_on_jump = 1
" let g:vista#renderer#enable_icon = 1
let g:vista_fzf_preview = ['right:50%']
if has_key(g:plugs, 'vista.vim')
    nnoremap <silent> <leader>bb :Vista!!<CR>
endif
" }}}
