local helpers = require'helpers'
local intelephense = require'plugins/config/nvim-lspconfig/intelephense'
local is_plugin_installed = helpers.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap
local g, cmd, fn = vim.g, vim.cmd, vim.fn

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

g['ale_hover_to_preview'] = 1

g['ale_completion_symbols'] = {
  text = '',
  method = '',
  ['function'] = '',
  constructor = '',
  field = '',
  variable = '',
  class = '',
  interface = '',
  ['module'] = '',
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
  ['<default>'] = 'v',
}
-- do not set the error sign background color to red. If I don't do this it looks weird with an emoji icon.
cmd('highlight! link ALEErrorSign ALEWarningSign')

-- strange that these are white by default - hard to differentiate between
cmd('highlight! link ALEVirtualTextError Comment')
cmd('highlight! link ALEVirtualTextWarning Comment')
cmd('highlight! link ALEVirtualTextInfo Comment')
cmd('highlight! link ALEVirtualTextStyleError Comment')
cmd('highlight! link ALEVirtualTextStyleWarning Comment')

if is_plugin_installed('ale') then
  nvim_set_keymap('n', '[w', ':ALEPreviousWrap<cr>', {noremap = true, silent = true})
  nvim_set_keymap('n', ']w', ':ALENextWrap<cr>', {noremap = true, silent = true})

  nvim_set_keymap('n', '[e', ':ALEPrevious -error<cr>', {noremap = true, silent = true})
  nvim_set_keymap('n', ']e', ':ALENext -error<cr>', {noremap = true, silent = true})

  nvim_set_keymap('n', '<leader>al', ':ALELint<cr>', {noremap = true})
  nvim_set_keymap('n', '<leader>af', ':ALEFix<cr>', {noremap = true})

  nvim_set_keymap('n', '<leader>rrv', 'ALERename<cr>', {noremap = true}) -- rename local variable
  nvim_set_keymap('n', '<leader>rrp', 'ALERename<cr>', {noremap = true}) -- rename class variable
  nvim_set_keymap('n', '<leader>rrm', 'ALERename<cr>', {noremap = true}) -- rename class method

  -- define intelephense lsp for linting
  fn['ale#Set']('php_intelephense_executable', 'intelephense')
  fn['ale#Set']('php_intelephense_use_global', 1)

  -- NOTE someone added `intelephense` as a linter but it's broken right now
  -- https://github.com/dense-analysis/ale/issues/3458 once this is fixed I
  -- hope I can remove this and just add the lsp config as a global var
  fn['ale#linter#Define']('php', {
    name = "intelephense-lsp",
    lsp = "stdio",
    lsp_config = intelephense,
    executable = 'intelephense',
    command = "%e --stdio",
    project_root = fn["ale_linters#php#langserver#GetProjectRoot"],
  })
end
