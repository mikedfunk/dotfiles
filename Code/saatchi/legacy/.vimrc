" vim: set foldmethod=marker:

" commands {{{
command! RunCurrentScript :AsyncRun eval `docker-machine env default` && docker exec -ti saatchi_legacy_instance php /data/code_base/current/% local -v<cr>
" edit services files on remote
command! -nargs=1 Edev execute "e scp://appdeploy@saatchi-xdev-legacy-services-01//data/code_base/current/" . <f-args>
command! -nargs=1 Eqa execute "e scp://appdeploy@saatchi-xqa-legacy-services-01//data/code_base/current/" . <f-args>
" }}}

" color {{{
" colo quantum
" let g:airline_theme = 'quantum'
" let g:quantum_italics = 1
" escape codes for italic fonts
" set t_ZH=[3m
" set t_ZR=[23m
" highlight Comment cterm=italic
silent! colo base16-monokai
let g:airline_theme = 'base16_monokai'
" augroup sfdf44
"   au! FileType php highlight phpDocTags ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=italic
" augroup END

" challenger_deep
" let g:airline_theme = 'challenger_deep'
" }}}

" general {{{
set wildignore+=*/build/*,*/coverage/*,*/strings/vocabulary/*,*/public/media/js/lib/ckeditor/*,*/node_modules/*,*/assets/react/node_modules/*,*/.git/*,composer.phar,Session.vim,*.csv,.php_cs

let g:preview_window_is_open = 0
function! TriggerPreviewHover () abort
    if g:preview_window_is_open
        :pclose
        let g:preview_window_is_open = 0
        return
    endif
    :exe "ptag " . expand("<cword>")
    let g:preview_window_is_open = 1
endfunction

if has_key(g:plugs, 'ale')
    nnoremap <c-k> :call TriggerPreviewHover()<cr>
endif

" set completeopt+=preview
" }}}

" ale {{{
" NOTE: moved to main .vimrc.pluginconfig.vim
" If I don't do this, phpcbf fails on any file in the exclude-pattern :/
" let g:ale_php_phpcbf_executable = 'php ' . getcwd() . '/vendor/bin/phpcbf -q'
" let g:ale_php_phpcbf_executable = '~/.support/phpcbf-helper.sh'
" let g:ale_php_phpcbf_use_global = 1
"
" ['intelephense-lsp', 'intelephense', 'langserver', 'phan', 'php', 'phpcs', 'phpmd', 'phpstan', 'psalm', 'tlint']
let g:ale_linters = {}
let g:ale_linters['php'] = ['php', 'phpcs', 'phpmd']
let g:ale_linters['javascript'] = ['esline']
" ['intelephense-lsp', 'intelephense', 'langserver', 'phan', 'php', 'phpcs', 'phpmd', 'phpstan', 'psalm', 'tlint']
" ['eslint', 'fecs', 'flow', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']
" tradeoff to make saatchi not dead slow. <leader>af to fix, <leader>al to lint.
" let g:ale_lint_on_save = 0
let g:ale_lint_on_save = 1 " acceptable speed
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 0
" if (exists(':ALEDisable'))
"     :ALEDisable
" endif
" }}}

" javascript-libraries-syntax {{{
augroup jslibsyn_augroup
    autocmd!
    autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
augroup END
" }}}

" nvim-lspconfig {{{
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" }}}

" php.vim {{{
let g:php_version_id = 70033
" }}}

" phpcd {{{
" let g:phpcd_autoload_path = 'application/command_line_bootstrap.php'
" }}}

" vdebug {{{
if exists("g:vdebug_options")
    let g:vdebug_options['port'] = 9000
    let g:vdebug_options['path_maps'] = {
    \   '/data/code_base/current': '/Users/mikefunk/Code/saatchi/legacy'
    \}
endif
" }}}

" vim-flow {{{
let g:flow#enable = 0
" }}}

" vim-gutentags {{{
if executable('cscope') && has('cscope') && exists('g:gutentags_modules')
    " call add(g:gutentags_modules, 'cscope')
    " set cscopetag " this is set in ~/.vimrc
endif
" }}}

" vim-lsp {{{
augroup register_flow_lsp
    autocmd!
    au User lsp_setup call lsp#register_server({
                \ 'name': 'javascript support using typescript-language-server',
                \ 'cmd': {server_info->[&shell, &shellcmdflag, '/usr/local/bin/typescript-language-server --stdio']},
                \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
                \ 'whitelist': ['javascript', 'javascript.jsx'],
                \ })
    autocmd FileType javascript setlocal omnifunc=lsp#complete
    autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete
augroup END
" }}}

" vim-tbone {{{
if has_key(g:plugs, 'vim-tbone')
    " send selection to repl
    vnoremap <leader>r :Twrite 2<CR>
endif
" }}}
