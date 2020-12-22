" vim: set sw=2 ts=2 sts=2 et tw=78 foldmethod=marker filetype=vim:

" color {{{
" colo base16-google
" colo desertink
" colo apprentice
" colo apprentice
" colo Tomorrow-Night
" colo base16-atelier-dune
" colo base16-darktooth
" silent! :AirlineTheme base16
" colo OceanicNext
" let g:airline_theme = 'oceanicnext'
" colo despacio
" colo base16-gruvbox-dark-soft
silent! colo base16-gruvbox-dark-hard
let g:airline_theme = 'base16'
" }}}

" commands {{{
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-zed-01//data/shop/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-zed-01//data/shop/current/" . <f-args>
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

" php.vim {{{
let g:php_version_id = 70033
" }}}

" vdebug {{{
" can add multiple path maps to this array, just duplicate the line
" below and add another. remote is first, local is second.
" NOTE: You can't change this after loading because of a bug currently.
if exists('g:vdebug_options')
  let g:vdebug_options['path_maps'] = {
  \   '/data/shop/current': '/Users/mikefunk/Code/saatchi/zed'
  \}
  let g:vdebug_options['port'] = 9005
endif
" }}}

" vim-gutentags {{{
" if executable('cscope') && has('cscope') && exists('g:gutentags_modules')
"     call add(g:gutentags_modules, 'cscope')
"     " set cscopetag " this is set in ~/.vimrc
" endif
" }}}

" vim-jira-complete {{{
let b:jiracomplete_url = 'https://saatchiart.atlassian.net'
let b:jiracomplete_username = 'mike.funk'
" let b:jiracomplete_password = ''  " optional
" }}}

" vim-tbone {{{
" if has_key(g:plugs, 'vim-tbone')
"     " send selection to repl
"     vnoremap <leader>r :Twrite 2<CR>
" endif
" }}}
