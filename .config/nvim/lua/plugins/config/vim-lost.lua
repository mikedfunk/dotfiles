local helpers = require'helpers'
local create_augroup, is_plugin_installed = helpers.create_augroup, helpers.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('vim-lost') then
  return
end

create_augroup('vim_lost_config', {
    {"FileType", "php", "let b:lost_regex = '\\v^    \\w+.*function'"}
  })

nvim_set_keymap('n', 'gL', ':Lost<cr>', {noremap = true})
