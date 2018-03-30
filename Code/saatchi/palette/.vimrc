" vim: set foldmethod=marker:
" colo hybrid_material
" let g:airline_theme="base16_ocean"
" colo onedark
colo base16-onedark
let g:airline_theme="onedark"
" set wildignore+=*/vendor/*
set wildignore+=*/build/*,cscope.out,tags,.git/*,Session.vim

" vdebug {{{
" can add multiple path maps to this array, just duplicate the line
" below and add another. remote is first, local is second.
" NOTE: You can't change this after loading because of a bug currently.
let g:vdebug_options['path_maps'] = {
\   '/data/palette/current': '/Users/mikefunk/Sites/saatchi/palette'
\}
let g:vdebug_options['port'] = 9015
" }}}

" vim-php-fmt {{{
let g:phpfmt_standard = 'phpcs.xml'
" }}}

" edit on remote {{{
ab Edev e scp://saatchi-xdev-palette-01://data/palette/current/
ab Eqa1 e scp://saatchi-xqa-palette-01://data/palette/current/
ab Eqa2 e scp://saatchi-xqa-palette-02://data/palette/current/
" }}}

" ale fixers {{{
" remove php_cs_fixer
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'php': ['phpcbf', 'php_cs_fixer'],
\   'ruby': ['rubocop']
\}
" }}}
