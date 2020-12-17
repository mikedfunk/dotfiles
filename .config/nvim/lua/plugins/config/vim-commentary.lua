local helpers = require'helpers'
local create_augroup, is_plugin_installed = helpers.create_augroup, helpers.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

create_augroup('vim_commentary_config', {
  {'FileType', 'php', 'setlocal commentstring=//\\ %s'},
  {'FileType', 'haproxy', 'setlocal commentstring=#\\ %s'},
  {'FileType', 'neon', 'setlocal commentstring=#\\ %s'},
  {'FileType', 'gitconfig', 'setlocal commentstring=#\\ %s'},
  {'BufRead,BufNewFile', '.myclirc', 'setlocal commentstring=#\\ %s'},
  {'BufRead,BufNewFile', '.my.cnf', 'setlocal commentstring=#\\ %s'},
  {'FileType', 'plantuml', "setlocal commentstring=' %s"},
  {'BufRead,BufNewFile', '.env', 'setlocal commentstring=#\\ %s'},
})

if is_plugin_installed('vim-commentary') then
  nvim_set_keymap('n', '<leader>c<space>', ':Commentary<cr>', {noremap = true})
  nvim_set_keymap('v', '<leader>c<space>', ':Commentary<cr>', {noremap = true})
end
