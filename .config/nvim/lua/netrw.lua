local create_augroup = require'helpers'.create_augroup
local g, nvim_set_keymap = vim.g, vim.api.nvim_set_keymap

g['netrw_liststyle'] = 3 -- tree style
nvim_set_keymap('c', '%%', "<C-R>=fnameescape(expand('%:h')).'/'<cr>", {noremap = true}) -- http://vimcasts.org/episodes/the-edit-command/
nvim_set_keymap('n', '<c-e>', ":silent! Lex <C-R>=fnameescape(expand('%:h')).'/'<cr><cr>", {noremap = true, silent = true}) -- open netrw to current file

-- TIP: to cd to the directory of the current file:
-- `:cd %%` (or on generic vim: `:cd %:h`)
-- Then to cd back to git root:
-- `:Gcd` (or `:cd -`)
-- Useful for <c-x><c-f> for javascript imports
-- Also you can <c-o> when in insert mode to temporarily run commands and jump
-- back to insert mode when done

g['netrw_localrmdir'] = 'rm -r' -- Allow netrw to remove non-empty local directories
g['netwr_winsize'] = -40
g['netwr_banner'] = 0

-- https://github.com/vim/vim/issues/2329#issuecomment-350294641
create_augroup('netrw_fix', {
  {'BufRead,BufWritePost', 'scp://*', 'set backtrace=acwrite'},
})

-- https://vi.stackexchange.com/a/13012
-- Per default, netrw leaves unmodified buffers open. This autocommand
-- deletes netrw's buffer once it's hidden (using ':q', for example)
create_augroup('netrw_delete_hidden', {
  {"FileType", "netrw", "setlocal bufhidden=delete"},
})
