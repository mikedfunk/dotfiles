local helpers = require'helpers'
local is_plugin_installed, create_augroup = helpers.is_plugin_installed, helpers.create_augroup
local g, getenv = vim.g, vim.fn.getenv

g['gutentags_ctags_executable_ruby'] = 'ripper-tags -R --ignore-unsupported-options'
g['gutentags_project_info'] = {
  {type = 'php', file = 'composer.json'}
}
g['gutentags_ctags_exclude_wildignore'] = 0
g['gutentags_exclude_filetypes'] = {
  'gitcommit',
  'gitconfig',
  'gitrebase',
  'gitsendemail',
  'git',
  'json',
  'yaml'
}
g['gutentags_modules'] = {'ctags'}

create_augroup('git_no_gutentags', {
  {'FileType', 'gitrebase', 'let g:gutentags_modules = []'},
  {'FileType', 'gitcommit', 'let g:gutentags_modules = []'},
  {'FileType', 'git', 'let g:gutentags_modules = []'},
})

-- TODO how do I check for &diff?
-- if &diff
--     let g:gutentags_modules = []
-- endif

g['gutentags_ctags_exclude'] = {
  '.git',
  '*.log',
  '*.min.js',
  '*.coffee',
  'bootstrap.php.cache',
  'classes.php.cache',
  'app/cache',
  '__TwigTemplate_*'
}

-- tells cscope to respect the same exclude settings in ~/.ctags
-- NOTE: this applies to all gutentags modules, not just cscope! As such it
-- ignores files in .ignore, which broke _ide_helper.php integration. In the
-- end I just turned off cscope... it's not that helpful in php. Grepping for
-- usage is faster and more accurate.
g['gutentags_file_list_command'] = getenv('HOME') .. '/.support/cscope_find.sh'
