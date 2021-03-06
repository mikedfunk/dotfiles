" vim: set foldmethod=marker:

" general {{{
" colo hybrid_material
" let g:airline_theme="base16_ocean"
" colo onedark
" silent! colo base16-onedark
" let g:airline_theme="onedark"
" silent! colo base16-synth-midnight-dark
silent! colo base16-horizon-dark
" silent! colo base16-outrun-dark
" set wildignore+=*/vendor/*
set wildignore+=*/coverage/*
" this makes inactive tabs almost invisible
" let g:airline_theme = "base16"
let g:airline_theme = "base16_vim"
set wildignore+=*/build/*,cscope.out,tags,.git/*,Session.vim
" }}}

" helpers {{{
" TODO not sure if this is working
function! IsPluginInstalled(name) abort
    return exec("lua require'helpers'.is_plugin_installed('" . a:name . "')")
endfunction
" }}}

" completion-nvim {{{
" augroup enable-completion-nvim
"     autocmd!
"     autocmd BufEnter *.php lua require'completion'.on_attach()
" augroup END
" }}}

" vdebug {{{
" can add multiple path maps to this array, just duplicate the line
" below and add another. remote is first, local is second.
" NOTE: You can't change this after loading because of a bug currently.
if exists('g:vdebug_options')
    let g:vdebug_options['path_maps'] = {
    \   '/data/palette/current': '/Users/mikefunk/Code/saatchi/palette'
    \}
    let g:vdebug_options['port'] = 9015
endif
" }}}

" vim-php-fmt {{{
let g:phpfmt_standard = 'phpcs.xml'
" }}}

" ale {{{
" If I don't do this, phpcbf fails on any file in the exclude-pattern :/
let g:ale_php_phpcs_standard = '/Users/mikefunk/Code/saatchi/palette/phpcs-mike.xml'

let g:ale_php_phpcbf_standard = '/Users/mikefunk/Code/saatchi/palette/phpcs-mike.xml'
let g:ale_php_phpcbf_executable = '/Users/mikefunk/.support/phpcbf-helper.sh'
let g:ale_php_phpcbf_use_global = 1

let g:ale_php_phpmd_ruleset = '/Users/mikefunk/Code/saatchi/palette/phpmd-mike.xml'

let g:ale_php_cs_fixer_use_global = 1

let g:ale_php_phpstan_level = 4
let g:ale_php_phpstan_configuration = '/Users/mikefunk/Code/saatchi/palette/phpstan.neon'
" let g:ale_php_phpstan_executable = 'php /Users/mikefunk/Code/saatchi/palette/vendor/bin/phpstan'
" let g:ale_linters = ['intelephense', 'langserver', 'phan', 'php', 'phpcs', 'phpmd', 'phpstan', 'psalm']
let g:ale_linters = {'php': ['intelephense-lsp', 'php', 'phpcs', 'phpmd', 'phpstan']}
" let g:ale_linters = {'php': ['php', 'phpcs', 'phpmd', 'phpstan']}
" let g:ale_linters = {'php': ['intelephense']}
" let ale_fixers = {'php': ['phpcbf', 'php_cs_fixer', 'trim_whitespace', 'remove_trailing_lines', 'prettier']}
let ale_fixers = {'php': ['phpcbf', 'php_cs_fixer', 'trim_whitespace', 'remove_trailing_lines']}
" I hope to remove some of these someday... in the mean time just ,af to fix
" everything in greenfield files
" let g:ale_fix_on_save_ignore = {'php': ['phpcbf', 'php_cs_fixer', 'prettier']}
let g:ale_fix_on_save_ignore = {'php': ['phpcbf', 'php_cs_fixer']}
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1

" if has_key(g:plugs, 'ale')
"     augroup ale_php_symbol_search
"         autocmd!
"         autocmd FileType php nmap <leader>tt :ALESymbolSearch -relative<space>
"     augroup END
" endif

" moved here so I could do it differently in legacy/zed
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

" if has_key(g:plugs, 'ale')
    " nnoremap <c-k> :call TriggerALEHover()<cr>
    " inoremap <c-k> :call TriggerALEHover()<cr>
    " nnoremap <silent> gr :ALEFindReferences -relative<cr>
" endif

" }}}

" php.vim {{{
let g:php_version_id = 70033
" }}}

" vim-gutentags {{{
if executable('cscope') && has('cscope') && exists('g:gutentags_modules')
    call add(g:gutentags_modules, 'cscope')
    " set cscopetag " this is set in ~/.vimrc
endif
" }}}

" vim-tbone {{{
" if has_key(g:plugs, 'vim-tbone')
    " send selection to repl
    " vnoremap <leader>r :Twrite 2<CR>
" endif
" }}}

" nvim-lspconfig {{{

" moved this here to avoid probs with legacy, zed, etc.
" moved again to the on_attach function. https://github.com/neovim/nvim-lspconfig/issues/124#issuecomment-585620235
" moved it back here so I can disable it in other codebases
" moved it back to my lua config... we'll see how that works in legacy/zed lol
" augroup nvim_lsp_php
"     autocmd!
"     autocmd filetype php setlocal omnifunc=v:lua.vim.lsp.omnifunc
" augroup END

" augroup php_lsp_mappings
"     autocmd!

"     nnoremap <silent> <leader>cc <cmd>lua vim.lsp.buf.code_action()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> <leader><c-]> mz:tabe %<CR>`z<cmd>lua vim.lsp.buf.definition()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> <c-w><c-]> :vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>
"     autocmd FileType php nnoremap <silent> <c-w>} <cmd>lua peek_definition()<CR>
"     " autocmd CursorHold *.php lua peek_definition() -- this is neato but takes up too much space
"     " autocmd CursorHold *.php ALEHover -- Opens in preview window. Yuck.

"     autocmd FileType php nnoremap <buffer> <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"     autocmd FileType php inoremap <buffer> <silent> <c-k> <c-o><cmd>lua vim.lsp.buf.signature_help()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> 1gD <cmd>lua vim.lsp.buf.type_definition()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
"     " autocmd FileType php nnoremap <buffer> gr :References<CR>
"     autocmd FileType php nnoremap <buffer> <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
"     autocmd FileType php nnoremap <buffer> <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"     " unfortunately this doesn't work - some problem with the plugin in lua
"     " autocmd FileType php nnoremap <buffer> gW :WorkspaceSymbols<cr>
"     " autocmd FileType php nnoremap <buffer> <leader>tt :WorkspaceSymbols<cr>
"     autocmd FileType php nnoremap <buffer> <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
" augroup END

" }}}

" vista {{{
let g:vista_disable_statusline = 1
let g:vista_executive_for = {
  \ 'php': 'nvim_lsp',
  \ }
" }}}
