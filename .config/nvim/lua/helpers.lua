local api, cmd, fn, g, v, tbl_map = vim.api, vim.cmd, vim.fn, vim.g, vim.v, vim.tbl_map
local o, wo, bo = vim.o, vim.wo, vim.bo
local executable, has, filereadable, getenv, fnamemodify = fn.executable, fn.has, fn.filereadable, fn.getenv, fn.fnamemodify

local H = {}

function H.create_augroup(group_name, definition)
  cmd('augroup '..group_name)
  cmd('autocmd!')
  for _, def in ipairs(definition) do
    local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
    cmd(command)
  end
  cmd('augroup END')
end

local function split_string(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match)
  end
  return result
end

function H.minus_equals(setting, value)
  if setting == nil or setting == "" then
    return ""
  end

  local t = split_string(setting, ',')

  for key, val in pairs(t) do
    if val == value then
      table.remove(t, key)
    end
  end
  return table.concat(t, ',')
end

function H.plus_equals(setting, value)
  if setting == nil then
    setting = ""
  end

  if setting == "" then
    return value
  end

  local t = split_string(setting, ',')
  table.insert(t, value)
  return table.concat(t, ',')
end

function H.is_plugin_installed(check_plugin_name)
  -- not pretty but it gets the job done
  local plugin_utils = require('packer.plugin_utils')
  local opt_plugins, start_plugins = plugin_utils.list_installed_plugins()

  for typ, plugin_list in ipairs({opt_plugins, start_plugins}) do
    for plugin_path, _ in pairs(plugin_list) do
      local plugin_name = fnamemodify(plugin_path, ":t")
      if (check_plugin_name == plugin_name) then
        return true
      end
    end
  end
  return false
end

function _G.dump(...)
  local objects = tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

return H
