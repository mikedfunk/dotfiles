local helpers = require'helpers'
local plus_equals, create_augroup = helpers.plus_equals, helpers.create_augroup
local o, getenv = vim.o, vim.fn.getenv

-- intentionally global
function set_lua_path()
  o.path = plus_equals(o.path, getenv('HOME') .. '/.config/nvim/lua')
end

create_augroup('set_lua_path', {
  {'FileType', 'lua', 'lua set_lua_path()'},
})
