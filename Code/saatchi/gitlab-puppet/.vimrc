" vim: set foldmethod=marker:

" color {{{
" colo base16-atelier-estuary
" let g:airline_theme = "base16"
silent! colo base16-atelier-dune
let g:airline_theme = "base16_atelierdune"
" }}}

" folding {{{
augroup indent_folding
	autocmd!
	autocmd FileType haproxy set foldmethod=indent 
	autocmd FileType yaml set foldmethod=indent 
augroup END
" }}}

" fugitive {{{
let g:fugitive_gitlab_domains = ['https://gitlab.dmdmedia.net']
" }}}
