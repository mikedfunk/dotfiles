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

" commands {{{
" edit remote services code
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-palette-services-01//data/palette/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-palette-services-01//data/palette/current/" . <f-args>
" }}}

" ale fixers {{{
" remove php_cs_fixer
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'php': ['phpcbf', 'php_cs_fixer'],
\   'ruby': ['rubocop']
\}
" }}}
