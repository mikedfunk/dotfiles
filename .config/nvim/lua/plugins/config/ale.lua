local helpers = require'helpers'
local is_plugin_installed = helpers.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap
local g, cmd = vim.g, vim.cmd

g['ale_cache_executable_check_failures'] = 1
g['ale_lint_on_save'] = 1
g['ale_lint_on_enter'] = 0
g['ale_lint_on_filetype_changed'] = 0
g['ale_lint_on_text_changed'] = 'never'
g['ale_completion_autoimport'] = 1
g['ale_php_cs_fixer_options'] = '--config=.php_cs'
g['ale_sign_column_always'] = 1
g['ale_sign_warning'] = '⚠️'
g['ale_sign_error'] = '🚨'
g['ale_sign_info'] = 'ℹ️'
g['zenburn_high_Contrast'] = 1
g['ale_virtualtext_cursor'] = 1
g['ale_virtualtext_prefix'] = ' '
g['ale_sign_highlight_linenrs'] = 1

if is_plugin_installed('ale') then
  nvim_set_keymap('n', '[w', ':ALEPreviousWrap<cr>', {noremap = true, silent = true})
  nvim_set_keymap('n', ']w', ':ALENextWrap<cr>', {noremap = true, silent = true})

  nvim_set_keymap('n', '[e', ':ALEPrevious -error<cr>', {noremap = true, silent = true})
  nvim_set_keymap('n', ']e', ':ALENext -error<cr>', {noremap = true, silent = true})

  nvim_set_keymap('n', '<leader>al', ':ALELint<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>af', ':ALEFix<cr>', {noremap = true})
end

g['ale_hover_to_preview'] = 1

g['ale_completion_symbols'] = {
  text = '',
  method = '',
  -- function = '',
  constructor = '',
  field = '',
  variable = '',
  class = '',
  interface = '',
  module = '',
  property = '',
  unit = 'unit',
  value = 'val',
  enum = '',
  keyword = 'keyword',
  snippet = '',
  color = 'color',
  file = '',
  reference = 'ref',
  folder = '',
  enum_member = '',
  constant = '',
  struct = '',
  event = 'event',
  operator = '',
  type_parameter = 'type param',
  -- <default> = 'v',
}
g['ale_completion_symbols']['function'] = ''
g['ale_completion_symbols']['<default>'] = 'v'
-- do not set the error sign background color to red. If I don't do this it looks weird with an emoji icon.
cmd('highlight! link ALEErrorSign ALEWarningSign')

-- strange that these are white by default - hard to differentiate between
cmd('highlight! link ALEVirtualTextError Comment')
cmd('highlight! link ALEVirtualTextWarning Comment')
cmd('highlight! link ALEVirtualTextInfo Comment')
cmd('highlight! link ALEVirtualTextStyleError Comment')
cmd('highlight! link ALEVirtualTextStyleWarning Comment')

-- rename bindings
if is_plugin_installed('ale') then
  nvim_set_keymap('n', '<leader>rrv', 'ALERename<cr>', {noremap = true}) -- rename local variable
  nvim_set_keymap('n', '<leader>rrp', 'ALERename<cr>', {noremap = true}) -- rename class variable
  nvim_set_keymap('n', '<leader>rrm', 'ALERename<cr>', {noremap = true}) -- rename class method
end
