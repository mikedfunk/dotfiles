local is_plugin_installed = require'helpers'.is_plugin_installed
local g, nvim_set_keymap = vim.g, vim.api.nvim_set_keymap

g['toggle_list_no_mappings'] = 1

if not is_plugin_installed('vim-togglelist') then
  return
end

nvim_set_keymap('n', '<leader>ll', ':call ToggleLocationList()<cr>', {noremap = true})
nvim_set_keymap('n', '<leader>qq', ':call ToggleQuickfixList()<cr>', {noremap = true})
