" vim: set sw=2 ts=2 sts=2 et tw=78 foldmethod=marker filetype=vim:
" color {{{
" colo base16-google
" colo desertink
" colo apprentice
" colo apprentice
" colo Tomorrow-Night
" colo base16-atelier-dune
" colo base16-darktooth
" silent! :AirlineTheme base16
" colo OceanicNext
" let g:airline_theme = 'oceanicnext'
" colo despacio
" colo base16-gruvbox-dark-soft
colo base16-gruvbox-dark-hard
let g:airline_theme = 'base16'
" }}}

" vdebug {{{
" can add multiple path maps to this array, just duplicate the line
" below and add another. remote is first, local is second.
" NOTE: You can't change this after loading because of a bug currently.
let g:vdebug_options['path_maps'] = {
\   '/data/shop/current': '/Users/mikefunk/Sites/saatchi/yzed'
\}
let g:vdebug_options['port'] = 9005
" }}}

" vim-jira-complete {{{
let b:jiracomplete_url = 'https://saatchiart.atlassian.net'
let b:jiracomplete_username = 'mike.funk'
" let b:jiracomplete_password = ''  " optional
" }}}

" commands {{{
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-zed-01//data/shop/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-zed-01//data/shop/current/" . <f-args>
" }}}

" gutentags {{{
" let g:gutentags_project_info = [{"type": "php"}]
" }}}
