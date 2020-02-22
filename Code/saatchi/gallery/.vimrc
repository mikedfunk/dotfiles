" vim: set foldmethod=marker:

" general {{{
set wildignore +=coverage/*,node_modules/*,public/build/*,.http/*,log/*,tags,.git/*,Session.vim
" }}}

" color {{{
" colo base16-atelier-sulphurpool
" colo base16-woodland
" colo badwolf
" colo base16-default-dark
" let g:airline_theme = 'base16'
" colo sierra
" let g:airline_theme = 'base16_ashes'
" colo ayu
" let g:airline_theme = 'ayu'
" silent! colo base16-zenburn
silent! colo base16-outrun-dark
let g:airline_theme = 'base16'
" }}}

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
if exists('g:ale_fixers')
    let g:ale_fixers['javascript'] = ['prettier', 'eslint', 'importjs']
    " let g:ale_fixers['javascript'] = ['prettier_eslint', 'eslint', 'importjs']
endif
" }}}

" vdebug {{{
" can add multiple path maps to this array, just duplicate the line
" below and add another. remote is first, local is second.
" NOTE: You can't change this after loading because of a bug currently.
if exists('g:vdebug_options')
    let g:vdebug_options['path_maps'] = {
    \   '/data/gallery/current': '/Users/mikefunk/Code/saatchi/gallery'
    \}
    let g:vdebug_options['port'] = 9010
endif
" }}}

" vim-lsp (NOT WORKING) {{{
" augroup register_flow_lsp
"   autocmd!
"   " NOT WORKING: this old-ass version of flow doesn't include a lsp :facepalm:
"   autocmd User lsp_setup call lsp#register_server({
"         \ 'name': 'flow',
"         \ 'cmd': {server_info->['yarn flow', 'lsp']},
"         \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
"         \ 'whitelist': ['javascript', 'javascript.jsx'],
"         \ })
"   autocmd FileType javascript setlocal omnifunc=lsp#complete
"   autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete
" augroup END
" }}}

" vim-gutentags {{{
if executable('cscope') && has('cscope') && exists('g:gutentags_modules')
    call add(g:gutentags_modules, 'cscope')
    " set cscopetag " this is set in ~/.vimrc
endif
" }}}

" nvim-lsp {{{

" flow (NOT WORKING) {{{
if (has('nvim'))
  " NOT WORKING: this old-ass version of flow doesn't have an lsp included :facepalm:
" lua << EOF
" require'nvim_lsp'.flow.setup{
"   cmd = { "yarn", "flow", "lsp" }
" }
" EOF
"   augroup nvim_lsp_easel
"     autocmd!
"     autocmd filetype javascript.jsx setlocal omnifunc=v:lua.vim.lsp.omnifunc
"   augroup END
" endif
" }}}

" typescript (obviously NOT WORKING because this is in flowtype) {{{
" lua << EOF
" require'nvim_lsp'.tsserver.setup{}
" EOF
"   augroup nvim_lsp_easel
"     autocmd!
"     autocmd filetype javascript.jsx setlocal omnifunc=v:lua.vim.lsp.omnifunc
"   augroup END
" endif
" }}}

" }}}
