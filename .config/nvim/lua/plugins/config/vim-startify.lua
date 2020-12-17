local g, getcwd, getenv = vim.g, vim.fn.getcwd, vim.fn.getenv

g['ascii'] = {}
g['startify_custom_header'] = 'map(g:ascii + startify#fortune#boxed(), "\\"   \\".v:val")'
g['startify_bookmarks'] = {'~/.vimrc', '~/.vimrc.plugins'}

g['startify_enable_special'] = 0 -- show empty buffer and quit
g['startify_enable_unsafe'] = 1 -- speeds up startify but sacrifices some accuracy
g['startify_session_sort'] = 1 -- sort descending by last used
g['startify_skiplist'] = {'COMMIT_EDITMSG', '.DS_Store'} -- disable common but unimportant files
g['startify_files_number'] = 9 -- recently used
g['startify_session_persistence'] = 0 -- auto save session on exit like obsession
g['startify_session_dir'] = getenv('HOME') .. '/.vim/sessions' .. getcwd() -- gitsessions dir... but actually it's a pretty good idea to use even outside of gitsessions.

-- reorder and whitelist certain groups
g['startify_lists'] = {
  {type = 'sessions', header = {'   Sessions'}},
  {type = 'dir', header = {'   MRU ' .. getcwd()}},
  {type = 'commands', header = {'   Commands'}},
}
g['startify_change_to_dir'] = 0 -- this feature should not even exist. It is stupid.
