" vim: set foldmethod=marker:
" colo hybrid_material
" let g:airline_theme="base16_ocean"
" colo onedark
silent! colo base16-onedark
let g:airline_theme="onedark"
" set wildignore+=*/vendor/*
set wildignore+=*/build/*,cscope.out,tags,.git/*,Session.vim

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

" commands {{{
" edit remote services code
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-palette-services-01//data/palette/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-palette-services-01//data/palette/current/" . <f-args>

" docker run --rm -t -v $(pwd):/palette wata727/pahout /palette --ignore-paths=/palette/vendor --config=/palette/.pahout.yaml
" }}}

" ale {{{
" If I don't do this, phpcbf fails on any file in the exclude-pattern :/
let g:ale_php_phpcs_standard = '/Users/mikefunk/Code/saatchi/palette/phpcs-mike.xml'
let g:ale_php_phpcbf_standard = '/Users/mikefunk/Code/saatchi/palette/phpcs-mike.xml'
let g:ale_php_phpcbf_executable = '/Users/mikefunk/.support/phpcbf-helper.sh'
let g:ale_php_phpcbf_use_global = 1
let ale_fixers = {'php': ['phpcbf']}
let g:ale_php_phpstan_level = 4
let g:ale_php_phpstan_configuration = '/Users/mikefunk/Code/saatchi/palette/phpstan.neon'
" let g:ale_php_phpstan_executable = 'php /Users/mikefunk/Code/saatchi/palette/vendor/bin/phpstan'
" }}}

" vim-gutentags {{{
if executable('cscope') && has('cscope') && exists('g:gutentags_modules')
    call add(g:gutentags_modules, 'cscope')
    " set cscopetag " this is set in ~/.vimrc
endif
" }}}

" vim-tbone {{{
if has_key(g:plugs, 'vim-tbone')
    " send selection to repl
    vnoremap <leader>r :Twrite 2<CR>
endif
" }}}

" nvim-lsp {{{
augroup php_lsp_mappings
    autocmd!
    autocmd FileType php nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
    autocmd FileType php nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    autocmd FileType php nnoremap <silent> <leader><c-]> mz:tabe %<CR>`z<cmd>lua vim.lsp.buf.definition()<CR>
    autocmd FileType php nnoremap <silent> <c-w><c-]> :vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>
    " autocmd FileType php nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    " autocmd FileType php nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    " autocmd FileType php nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    " autocmd FileType php nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    " autocmd FileType php nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
augroup END
" }}}

" vista {{{
let g:vista_disable_statusline = 1
" }}}
