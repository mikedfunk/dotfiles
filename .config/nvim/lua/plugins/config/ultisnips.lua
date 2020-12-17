local is_plugin_installed = require'helpers'.is_plugin_installed
local g, getenv, nvim_set_keymap = vim.g, vim.fn.getenv, vim.api.nvim_set_keymap

g['snips_author'] = 'Michael Funk <mike.funk@leafgroup.com>'
g['UltiSnipsEditSplit'] = 'vertical'
g['UltiSnipsExpandTrigger'] = '<c-l>' -- default: <Tab>

-- NOTE: do not mess with this config value, you are going to have a bad time.
g['UltiSnipsSnippetDirectories'] = {
  'UltiSnips',
  getenv('HOME') .. '/.config/nvim/UltiSnips',
}
if is_plugin_installed('ultisnips') then
  nvim_set_keymap('i', '<c-j>', '<c-r>=UltiSnips#JumpForwards()<CR>', {noremap = true}) -- UltiSnips somehow forgets this mapping when I open a new file :/
end
