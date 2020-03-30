" vim: set foldmethod=marker:

" ale {{{
" disabled prettier-eslint until this PR is applied
" https://github.com/prettier/prettier-eslint/pull/194
" call add(g:ale_fixers['javascript'], 'prettier_eslint')
"
" disabled prettier because I'm using the recommended eslint plugin instead
" (in an easel branch that's waiting to be merged)
" https://prettier.io/docs/en/eslint.html#docsNav
" let g:ale_fixers['javascript'] = ['prettier', 'eslint', 'importjs']
let g:ale_fixers['javascript'] = ['eslint', 'importjs']
let g:ale_javascript_prettier_options = '--trailing-comma es5'
" }}}

" color {{{
"
" colo base16-grayscale-dark
" let g:airline_theme="base16_grayscale"
"
" colo base16-circus
" let g:airline_theme="tomorrow"
"
" BRIGHT O_O
" colo base16-irblack
" let g:airline_theme="powerlineish"

" bright with blue split lines and blue/green/teal colors
silent! colo base16-seti
let g:airline_theme="base16_seti"
" }}}

" jsx {{{
augroup jsxgrp
    autocmd!
    autocmd BufRead,BufNewFile *.js set ft=javascript.jsx
augroup END

" TODO set up contextual commenting based on region
command! JsComments setlocal commentstring=//\ %s
command! JsxComments setlocal commentstring={/*\ %s\ */}
" }}}

" javascript-libraries-syntax {{{
autocmd BufReadPre *.js let b:javascript_lib_use_underscore = 1 " lodash
autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
" }}}

" nvim-lsp (works!) {{{
if (has('nvim'))
lua << EOF
require'nvim_lsp'.flow.setup{
  cmd = { "yarn", "flow", "lsp" }
}
EOF
  augroup nvim_lsp_easel
    autocmd!
    autocmd filetype javascript.jsx setlocal omnifunc=v:lua.vim.lsp.omnifunc
  augroup END
endif

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" }}}

" tern {{{
" I use vim-flow instead for completion
let g:tern_set_omni_function = 0
" }}}

" vim-gutentags {{{
let g:gutentags_modules = []
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

" vim-tbone {{{
if has_key(g:plugs, 'vim-tbone')
    " send selection to repl
    vnoremap T :Twrite 2<CR>
endif
" }}}
