local is_plugin_installed = require'helpers'.is_plugin_installed
local g, fn, nvim_set_keymap = vim.g, vim.fn, vim.api.nvim_set_keymap

g['which_key_map'] = {
  r = 'refactor',
  g = {
    name = 'git/grep',
    g = 'grep',
  },
  f = {
    name = 'files',
    f = 'fuzzy search files',
  },
  b = {
    name = 'buffer/tagbar',
    b = 'toggle tagbar',
    n = 'next buffer',
    p = 'previous buffer',
  },
  c = {
    name = 'comment',
    ['<space>'] = 'toggle',
  },
  a = {
    name = 'ale',
    l = 'lint',
    f = 'fix',
  },
  u = {
    name = 'undo',
    u = 'undo',
  },
}

if not is_plugin_installed('vim-which-key') then
  return
end

fn['which_key#register']('<leader>', 'g:which_key_map')

nvim_set_keymap('n', '<leader>', ':<c-u>WhichKey "<Space>"<cr>', {noremap = true, silent = true})
nvim_set_keymap('v', '<leader>', ':<c-u>WhichKeyVisual "<Space>"<cr>', {noremap = true, silent = true})
