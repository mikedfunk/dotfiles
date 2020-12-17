local cmd = vim.cmd
local helpers = require'helpers'
local is_plugin_installed = helpers.is_plugin_installed

if is_plugin_installed('base16-vim') then
  cmd('silent! colorscheme base16-atlas') -- very solarized-y but more colorful
end
