" vim: set foldmethod=marker:

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
colo base16-seti
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

" ale {{{
" disabled until this PR is applied https://github.com/prettier/prettier-eslint/pull/194
" call add(g:ale_fixers['javascript'], 'prettier_eslint')
" }}}

" tern {{{
" I use vim-flow instead for completion
let g:tern_set_omni_function = 0
" }}}
