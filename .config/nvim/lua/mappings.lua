local nvim_set_keymap, nvim_exec = vim.api.nvim_set_keymap, vim.api.nvim_exec

nvim_set_keymap('n', '<leader>so', ":lua require'plugins'<cr>", {noremap = true})
-- from practical vim recommendation
nvim_set_keymap('c', '<c-p>', '<Up>', {noremap = true})
nvim_set_keymap('c', '<c-n>', '<Down>', {noremap = true})

-- put cursor at end of text on y and p
nvim_set_keymap('v', 'y', 'y`]', {noremap = true, silent = true})
nvim_set_keymap('v', 'p', 'p`]', {noremap = true, silent = true})
nvim_set_keymap('n', 'p', 'p`]', {noremap = true, silent = true})

-- Visual shifting (does not exit Visual mode)
nvim_set_keymap('v', '<', '<gv', {noremap = true})
nvim_set_keymap('v', '>', '>gv', {noremap = true})

-- Wrapped lines goes down/up to next row, rather than next line in file.
nvim_set_keymap('n', 'j', "v:count ? 'j' : 'gj'", {noremap = true, expr = true})
nvim_set_keymap('n', 'k', "v:count ? 'k' : 'gk'", {noremap = true, expr = true})

-- Easier horizontal scrolling
nvim_set_keymap('n', 'zl', 'zL', {noremap = true})
nvim_set_keymap('n', 'zh', 'zH', {noremap = true})

-- my version of fast tabs. Doesn't work in netrw tabs.
nvim_set_keymap('n', 'gh', 'gT', {noremap = true})
nvim_set_keymap('n', 'gl', 'gt', {noremap = true})
nvim_set_keymap('n', "<c-w>t", 'mz:tabe %<cr>`z', {noremap = true})

-- for all tag jumps, show the menu when there are more than one result! if
-- only one result, jump away. :h tjump. I don't see why I would want to do it
-- any other way!! The default sucks - it sometimes takes me to the wrong match
-- because it's the first match.
-- nvim_set_keymap('n', '<c-]>', ':exec("tjump ".expand("<cword>"))<cr>', {noremap = true})

-- TODO convert to lua
-- open tag in tab
-- this should really just be <c-w>g<c-]> then <c-w>T but I couldn't get that
-- to work
-- function! OpenTagInNewTab () abort
--     :normal! mz
--     :tabe %
--     :normal! `z
--     :exec("tjump ".expand('<cword>'))
-- endfunction
-- nnoremap <silent><leader><c-]> :call OpenTagInNewTab()<cr>

-- nvim_set_keymap('n', '<c-w><c-]>', ':vsp<CR>:exec("tjump ".expand("<cword>"))<CR>', {noremap = true}) -- open tag in vertical split
-- nvim_set_keymap('n', '<c-w>}', ':exec("ptjump ".expand("<cword>"))<CR>', {noremap = true}) -- open tag in preview window (<c-w><c-z> to close)

-- stupid f1 help
nvim_set_keymap('n', '<f1>', '<nop>', {noremap = true})
nvim_set_keymap('i', '<f1>', '<nop>', {noremap = true})

-- TODO convert to lua
-- " switch to the last active tab
-- let g:lasttab = 1
-- nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
-- augroup tableavegroup
--     autocmd!
--     autocmd TabLeave * let g:lasttab = tabpagenr()
-- augroup END

nvim_set_keymap('n', '<leader>fa', ':delmarks z<cr>hh :echo "formatted file"<cr>', {noremap = true}) -- format all

nvim_set_keymap('n', '<leader>wg', ':grep! <cword> .<cr>', {noremap = true})
nvim_set_keymap('n', '<leader>Wg', ':grep! "\b<cword>\b" .<cr>', {noremap = true})

-- fuzzy open
nvim_set_keymap('n', '<leader>fe', ':e **/*', {noremap = true})
nvim_set_keymap('n', '<leader>ft', ':tabe **/*', {noremap = true})
nvim_set_keymap('n', '<leader>ft', ':vsp **/*', {noremap = true})
nvim_set_keymap('n', '<leader>fs', ':sp **/*', {noremap = true})

nvim_set_keymap('n', '<leader>je', ':tjump<space>', {noremap = true})
nvim_set_keymap('n', '<leader>jv', ':vsp<CR>:tag<space>', {noremap = true})
nvim_set_keymap('n', '<leader>jt', ':tabe<CR>:tag<space>', {noremap = true})

-- diffs
nvim_set_keymap('n', '<leader>dr', ':diffget REMOTE<cr>', {noremap = true})
nvim_set_keymap('n', '<leader>dl', ':diffget LOCAL<cr>', {noremap = true})

-- TODO convert to lua
-- " open current file in browser (useful for markdown preview)
-- function! PreviewInBrowser() abort
--     " silent !open -a "Google Chrome" %:p
--     silent !open -a "Firefox" %:p
--     redraw!
-- endfunction
-- command! PreviewInBrowser :call PreviewInBrowser()


-- TODO conver to lua - problem with quotes
-- http://vim.wikia.com/wiki/Highlight_current_line
-- nnoremap <silent> <Leader>hl :exe "let m = matchadd('Search','\\%" . line('.') . "l')"<CR>
-- nnoremap <silent> <Leader>hw :exe "let m=matchadd('Search','\\<\\w*\\%" . line(".") . "l\\%" . col(".") . "c\\w*\\>')"<CR>
-- nnoremap <silent> <Leader>hc :call clearmatches()<CR>

nvim_set_keymap('n', '<leader>zz', ':lua vim.lsp.buf.code_action()<cr>', {noremap = true})
