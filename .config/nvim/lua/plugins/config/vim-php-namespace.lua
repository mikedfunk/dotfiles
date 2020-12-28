local helpers = require'helpers'
local is_plugin_installed, create_augroup = helpers.is_plugin_installed, helpers.create_augroup
local g, nvim_buf_set_keymap = vim.g, vim.api.nvim_buf_set_keymap

g['php_namespace_sort_after_insert'] = 1

if not is_plugin_installed('vim-php-namespace') then
  return
end

-- intentionally global
function set_up_vim_php_namespace()
  nvim_buf_set_keymap(0, 'i', '<leader><leader>u', '<C-O>:call PhpInsertUse()<cr>', {noremap = true})
  nvim_buf_set_keymap(0, 'n', '<leader><leader>u', ':call PhpInsertUse()<cr>', {noremap = true})

  nvim_buf_set_keymap(0, 'i', '<leader><leader>e', '<C-O>:call PhpExpandClass()<cr>', {noremap = true})
  nvim_buf_set_keymap(0, 'n', '<leader><leader>e', '<C-O>:call PhpExpandClass()<cr>', {noremap = true})
end

create_augroup('vim_lost', {
  {'FileType', 'php', "lua set_up_vim_php_namespace()"},
})
