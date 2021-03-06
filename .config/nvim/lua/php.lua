local create_augroup = require'helpers'.create_augroup
local g, cmd, nvim_exec, nvim_set_keymap = vim.g, vim.cmd, vim.api.nvim_exec, vim.api.nvim_set_keymap

g['PHP_removeCRwhenUnix'] = 1
-- means that PHP tags will match the indent of the HTML around them in files that a mix of PHP and HTML
g['PHP_outdentphpescape'] = 0
g['php_htmlInStrings'] = 1 -- neat! :h php.vim
g['php_baselib'] = 1 -- highlight php builtin functions
-- g['php_folding'] = 1 -- fold methods, control structures, etc.
g['php_noShortTags'] = 1
g['php_parent_error_close'] = 1 -- highlight missing closing ] or )
g['php_parent_error_open'] = 1 -- highlight missing opening [ or (
g['php_syncmethod'] = 10 -- :help :syn-sync https://stackoverflow.com/a/30732393/557215

-- doxygen support is _extremely_ buggy for php in neovim. Works fine in vim.
-- e.g. if a class is taller than the current viewport and you go to the last
-- curly brace in a class, it breaks syntax until you page back up to whatever
-- line breaks it. Then if you go back to the last curly brace it breaks again.
-- Not worth it. Apparently it has something to do with php extending html as
-- the broken highlight group is `htmlError`. It could be related to this
-- https://github.com/sheerun/vim-polyglot/blob/28388008327aacfc48db3c31f415564d93cd983f/syntax/php.vim#L73
-- I think it has to do with nested braces in parens.
-- :h doxygen
-- g['load_doxygen_syntax'] = 1 -- pretty docblocks in php, c, etc.
-- g['doxygen_enhanced_color'] = 1 -- prettier docblocks

create_augroup('php_sort_use', {
    -- sort use statements alphabetically
  {"FileType", "php", "nnoremap <leader>su :call PhpSortUse()<cr>"},
})

-- TODO fix invalid escape sequence
-- create_augroup('php_expand_interface_methods', {
  -- {"FileType", "php", 'nnoremap <leader>ei :%s/\v(\w+\sfunction\s\w+\(.*\))(\: \w+)?;/\1\2\r    {\r        \/\/\r    }/g<cr>'},
-- })

create_augroup('php_methods_to_interface_signatures', {
  -- methods to interface signatures,
  {"FileType", "php", "nnoremap <leader>em :%g/    public function/normal! jd%kA;<cr>"},
})

create_augroup('php_single_to_multi_docblock', {
    -- convert single line /** @var something */ to multiline:
    -- /**
    --  * @var something
    --  */
  {'FileType', 'php', ":nnoremap <leader>cm :.,.s/\\/\\*\\* \\(.*\\) \\*\\//\\/\\*\\*\\r     * \\1\\r     *\\//g<cr>"}
})

-- array() to []
-- TODO doesn't work
-- nvim_exec(
-- [[
-- augroup phpfixarray
--   autocmd!
--   autocmd FileType php nnoremap <leader>xa mv?array(
-- f(mz%r]`zr[hvFa;d`v
-- augroup END
-- ]], true)

-- TODO convert to lua
nvim_exec(
[[
" prefix php namespaces
function! PhpPrefixNamespaces() abort
    silent! %s/@\([a-z]\+\) \([A-Z]\)/@\1 \\\2/g
    silent! %s/@author \\/@author /g
    nohlsearch
endfunction
command! PhpPrefixNamespaces :call PhpPrefixNamespaces()
]], true)

create_augroup('php_break_chain_map', {
  {'FileType', 'php', 'nnoremap <leader>. ^f-i<enter><esc>'},
})

cmd('highlight! link phpDocTags phpDefine')
cmd('highlight! link phpDocParam phpType')
cmd('highlight! link phpDocParam phpRegion')
cmd('highlight! link phpDocIdentifier phpIdentifier')
cmd('highlight! link phpUseNamespaceSeparator Comment') -- Colorize namespace separator in use, extends and implements
cmd('highlight! link phpClassNamespaceSeparator Comment')
