" vim: set foldmethod=marker:

" colorscheme {{{
" colo ayu
" let g:airline_theme = 'ayu'
silent! colo base16-chalk
let g:airline_theme="base16_chalk"
" }}}

" filetypes {{{
augroup filetypesgroup
    autocmd!
    autocmd Bufenter,BufNewFile Dockerfile-* set ft=dockerfile
    autocmd Bufenter,BufNewFile *.ini.template set ft=dosini
    autocmd Bufenter,BufNewFile *.conf set ft=nginx sw=2 ts=2 et
augroup END
" }}}
