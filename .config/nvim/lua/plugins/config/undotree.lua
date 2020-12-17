local is_plugin_installed = require'helpers'.is_plugin_installed
local g, nvim_set_keymap = vim.g, vim.api.nvim_set_keymap

g['undotree_SetFocusWhenToggle'] = 1

if is_plugin_installed('undotree') then
    nvim_set_keymap('n', '<leader>uu', ':UndotreeToggle<CR>', {noremap = true}) -- toggle undotree window
end
