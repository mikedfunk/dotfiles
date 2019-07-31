" vim: set foldmethod=marker:

" color {{{
" colo despacio
" let g:airline_theme = base16
" colo gotham256
" let g:airline_theme = gotham
" colo afterglow
" colo base16-unikitty-dark
" silent! colo base16-3024
" let g:airline_theme = 'base16_3024'
silent! colo base16-summerfruit-dark
let g:airline_theme = 'base16_summerfruit'
" call plug#begin('~/.vim/plugged')
" Plug 'diepm/vim-rest-console', { 'for': 'rest', 'tag': 'v2.6.0' } " like above but more capable
" call plug#end()
" let g:airline_theme = 'afterglow'
" }}}

" vrc {{{
" this is to allow our shitty ruby catalog GET with json body requests :/
" https://github.com/diepm/vim-rest-console/issues/19
let g:vrc_allow_get_request_body=1
" }}}
