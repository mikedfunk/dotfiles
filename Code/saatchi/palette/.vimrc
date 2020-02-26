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

" fixers {{{
let g:ale_php_phpcbf_executable = '/Users/mikefunk/.support/phpcbf-helper.sh'
let g:ale_php_phpcbf_use_global = 1
" let g:ale_php_phpstan_level = 4
" remove php_cs_fixer
" let ale_fixers['php'] = ['phpcbf', 'php_cs_fixer']
" let ale_fixers['php'] = ['php_cs_fixer']
" If I don't do this, phpcbf fails on any file in the exclude-pattern :/
" let g:ale_php_phpcbf_executable = '/Users/mikefunk/.support/phpcbf-helper.sh'

" This is a pain in the ass, but phpcbf and ale kept wiping any files in the
" exclude-pattern. I couldn't get the executable above to be recognized, so I
" set it directly in the plugin config to test. I STILL got the dreaded 'No
" fixable errors were found' message replaced over the contents of the file.
"
" I could get the bash wrapper to work sometimes
" let g:ale_php_fixers_backup = get(g:, "ale_fixers")['php']
" function! RestoreAlePhpFixers() abort
"     let g:ale_fixers['php'] = get(g:, 'ale_php_fixers_backup')
" endfunction

" function! RemoveAlePhpFixers() abort
"     let g:ale_php_fixers_backup = g:ale_fixers['php']
"     let g:ale_fixers['php'] = ['php_cs_fixer']
" endfunction

" augroup phpcbf_not_tests
"     autocmd!
"     autocmd BufEnter *.php call RestoreAlePhpFixers()
" augroup END

" augroup phpcbf_tests
"     autocmd!
"     autocmd BufEnter *{Test,Spec}.php call RemoveAlePhpFixers()
" augroup END

" let g:ale_fixers = {
" \   'javascript': ['eslint'],
" \   'php': ['phpcbf', 'php_cs_fixer'],
" \   'ruby': ['rubocop']
" \}
" }}}

" linters {{{
" call add(g:ale_linters['php'], 'langserver')
" }}}

" }}}

" vim-gutentags {{{
if executable('cscope') && has('cscope') && exists('g:gutentags_modules')
    call add(g:gutentags_modules, 'cscope')
    " set cscopetag " this is set in ~/.vimrc
endif
" }}}

" lsp {{{
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" }}}
