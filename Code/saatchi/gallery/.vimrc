" vim: set foldmethod=marker:
" colo base16-atelier-sulphurpool
" colo base16-woodland
" colo badwolf
" colo base16-default-dark
" let g:airline_theme = 'base16'
" colo sierra
" let g:airline_theme = 'base16_ashes'
" colo ayu
" let g:airline_theme = 'ayu'
colo base16-zenburn
let g:airline_theme = 'base16'

set wildignore +=coverage/*,node_modules/*,node_modules_fuck_npm/*,public/build/*,.http/*,log/*,tags,.git/*,Session.vim

" jsx/javascript {{{
" let b:javascript_lib_use_flux = 1
let g:jsx_ext_required = 0

augroup jsxgrp
    autocmd!
    autocmd BufRead,BufNewFile *.js set ft=javascript.jsx
augroup END
" }}}

" javascript-libraries-syntax {{{
autocmd BufReadPre *.js let b:javascript_lib_use_underscore = 1 " lodash
autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
" }}}

" ale {{{
" if executable('prettier-eslint') | call add(js_linters, 'prettier_eslint') | endif
" * JavaScript: `eslint`, `flow`, `jscs`, `jshint`, `prettier`, `prettier-eslint` >= 4.2.0, `prettier-standard`, `standard`, `xo`
let g:ale_fixers['javascript'] = ['prettier_eslint', 'eslint', 'importjs']
" }}}

" vdebug {{{
" can add multiple path maps to this array, just duplicate the line
" below and add another. remote is first, local is second.
" NOTE: You can't change this after loading because of a bug currently.
let g:vdebug_options['path_maps'] = {
\   '/data/gallery/current': '/Users/mikefunk/Code/saatchi/gallery'
\}
let g:vdebug_options['port'] = 9010
" }}}

" edit on remote {{{
ab Edev e scp://saatchi-xdev-gallery-01://data/gallery/current/
ab Eqa1 e scp://saatchi-xqa-gallery-01://data/gallery/current/
ab Eqa2 e scp://saatchi-xqa-gallery-02://data/gallery/current/
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-gallery-01//data/gallery/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-gallery-01//data/gallery/current/" . <f-args>
" }}}

" vim-lsp {{{
augroup register_flow_lsp
  autocmd!
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['yarn flow', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
  autocmd FileType javascript setlocal omnifunc=lsp#complete
  autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete
augroup END
" }}}
