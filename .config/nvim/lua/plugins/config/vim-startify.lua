local g, getcwd, getenv, nvim_set_keymap = vim.g, vim.fn.getcwd, vim.fn.getenv, vim.api.nvim_set_keymap

g['ascii'] = {}
g['startify_custom_header'] = 'map(g:ascii + startify#fortune#boxed(), "\\"   \\".v:val")'
-- g['startify_bookmarks'] = {'~/.config/nvim/init.lua', '~/.zshrc', '~/.tmux.conf', '~/.saatchirc'}

g['startify_enable_special'] = 0 -- show empty buffer and quit
g['startify_enable_unsafe'] = 1 -- speeds up startify but sacrifices some accuracy
g['startify_session_sort'] = 1 -- sort descending by last used
g['startify_skiplist'] = {'COMMIT_EDITMSG', '.DS_Store'} -- disable common but unimportant files
g['startify_files_number'] = 9 -- recently used
g['startify_session_persistence'] = 0 -- auto save session on exit like obsession
g['startify_session_dir'] = getenv('HOME') .. '/.local/share/nvim/session' .. getcwd() -- session dir for each repo

-- reorder and whitelist certain groups
g['startify_lists'] = {
  {type = 'sessions', header = {'   Sessions'}},
  {type = 'dir', header = {'   Recent in ' .. getcwd()}},
  {type = 'commands', header = {'   Commands'}},
}
g['startify_change_to_dir'] = 0 -- this feature should not even exist. It is stupid.

nvim_set_keymap('n', '<leader>ss', ':SSave<cr>', {noremap = true}) -- disable Ex mode
nvim_set_keymap('n', '<leader>sl', ':SLoad<cr>', {noremap = true}) -- disable Ex mode
nvim_set_keymap('n', '<leader>sd', ':SDelete<cr>', {noremap = true}) -- disable Ex mode
