local helpers = require'helpers'
local is_plugin_installed = helpers.is_plugin_installed
local g, cmd = vim.g, vim.cmd
local nvim_set_keymap = vim.api.nvim_set_keymap

g['nnn#replace_netrw'] = 1
g['nnn#set_default_mappings'] = 0

local nnn_action = {}
nnn_action['<c-t>'] = 'tab split'
nnn_action['<c-x>'] = 'split'
nnn_action['<c-v>'] = 'vsplit'
g['nnn#action'] = nnn_action

-- Floating window (neovim latest and vim with patch 8.2.191)
g['nnn#layout'] = {
  window = {
    width = 0.9,
    height = 0.6,
    highlight = 'Debug',
  }
}

if is_plugin_installed('nnn.vim') then
  nvim_set_keymap('n', '-', ':NnnPicker %<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>ee', ':NnnPicker<cr>', {noremap = true})
  cmd('command! -bang -nargs=* -complete=file Ex NnnPicker <args>')
  cmd('command! -bang -nargs=* -complete=file Explore NnnPicker <args>')
end
