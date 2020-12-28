local helpers = require'helpers'
local create_augroup = helpers.create_augroup
local g = vim.g

g['blamer_enabled'] = 1
g['blamer_show_in_visual_modes'] = 0
g['blamer_show_in_insert_modes'] = 0
g['blamer_prefix'] = '    '
-- g['blamer_prefix'] = '  ✎ ' -- this is cool but it shows an empty pencil in files not tracked by git :/.

g['blamer_relative_time'] = 1

create_augroup('blamer_blacklist', {
  {'FileType', 'gitcommit', "lua vim.g['blamer_enabled'] = false"},
})
