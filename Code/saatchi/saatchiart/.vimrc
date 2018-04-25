" vim: set foldmethod=marker:

" general {{{
set wildignore+=*/build/*,*/coverage/*,*/strings/vocabulary/*,*/public/media/js/lib/ckeditor/*,*/node_modules/*,*/assets/react/node_modules/*,*/.git/*,composer.phar,Session.vim,*.csv,.php_cs
" }}}

" color {{{
" colo quantum
" let g:airline_theme = 'quantum'
" let g:quantum_italics = 1
" escape codes for italic fonts
" set t_ZH=[3m
" set t_ZR=[23m
" highlight Comment cterm=italic
colo base16-monokai
let g:airline_theme = 'base16_monokai'
" augroup sfdf44
"   au! FileType php highlight phpDocTags ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=italic
" augroup END

" challenger_deep
" let g:airline_theme = 'challenger_deep'
" }}}

" vdebug {{{
let g:vdebug_options['port'] = 9000
let g:vdebug_options['path_maps'] = {
\   '/data/code_base/current': '/Users/mikefunk/Code/saatchi/saatchiart'
\}
" }}}

" ale {{{
" NOTE: moved to main .vimrc.pluginconfig.vim
" If I don't do this, phpcbf fails on any file in the exclude-pattern :/
" let g:ale_php_phpcbf_executable = 'php ' . getcwd() . '/vendor/bin/phpcbf -q'
" let g:ale_php_phpcbf_executable = '~/.support/phpcbf-helper.sh'
" let g:ale_php_phpcbf_use_global = 1
" }}}

" javascript-libraries-syntax {{{
augroup jslibsyn_augroup
    autocmd!
    autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
augroup END
" }}}

" commands {{{
command! RunCurrentScript :AsyncRun eval `docker-machine env default` && docker exec -ti saatchi_legacy_instance php /data/code_base/current/% local -v<cr>
" edit services files on remote
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-legacy-services-01//data/code_base/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-legacy-services-01//data/code_base/current/" . <f-args>
" }}}
