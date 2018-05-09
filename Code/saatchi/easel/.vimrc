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

" TODO set up contextual commenting based on region
command! JsComments setlocal commentstring=//\ %s
command! JsxComments setlocal commentstring={/*\ %s\ */}
" }}}

" javascript-libraries-syntax {{{
autocmd BufReadPre *.js let b:javascript_lib_use_underscore = 1 " lodash
autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
" }}}

" ale {{{
call add(g:ale_fixers['javascript'], 'prettier_eslint')
" }}}

" tern {{{
" I use vim-flow instead for completion
let g:tern_set_omni_function = 0
" }}}
