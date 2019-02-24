" NOTE: not currently working. It passes the executable check, but on :ALELint
" it does not start the language server. Not sure wtf is going on.
"
" set up php intelephense server as a lsp provider for linting and completion
" because php-language-server.php is a pain and doesn't work
" :h ale-lint
" https://github.com/bmewburn/intelephense-server
function! ale_linters#php#intelephense#GetProjectRoot(buffer) abort
    let l:git_path = ale#path#FindNearestDirectory(a:buffer, '.git')

    return !empty(l:git_path) ? fnamemodify(l:git_path, ':h:h') : ''
endfunction

" I have to set the executable to something that is +x, which is why I have
" executable and command reversed here
call ale#linter#Define('php', {
            \   'name': 'intelephense',
            \   'lsp': 'stdio',
            \   'executable': $HOME.'/.nodenv/shims/node'),
            \   'command': '%e '.$HOME.'/.config/yarn/global/node_modules/intelephense-server/lib/server.js',
            \   'project_root': function('ale_linters#php#intelephense#GetProjectRoot'),
            \})
