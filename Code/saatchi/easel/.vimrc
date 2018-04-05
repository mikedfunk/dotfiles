" vim: set foldmethod=marker:

" color {{{
" colo base16-grayscale-dark
" let g:airline_theme="base16_grayscale"
colo base16-circus
let g:airline_theme="base16"
" }}}

" jsx {{{
augroup jsxgrp
    autocmd!
    autocmd BufRead,BufNewFile *.js set ft=javascript.jsx
augroup END
" }}}

" javascript-libraries-syntax {{{
autocmd BufReadPre *.js let b:javascript_lib_use_underscore = 1 " lodash
autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
" }}}