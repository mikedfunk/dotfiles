local helpers = require'helpers'
local create_augroup, is_plugin_installed = helpers.create_augroup, helpers.is_plugin_installed
local g, getenv, call, nvim_exec = vim.g, vim.fn.getenv, vim.call, vim.api.nvim_exec

if not is_plugin_installed('asyncrun.vim') or not is_plugin_installed('vim-airline') then
  return
end

-- vim-airline integration

-- intentionally global
function asyncrun_airline_init()
  g['airline_section_z'] = call('airline#section#create_right', {'%{g:asyncrun_status} ' .. g['airline_section_z']})
end

create_augroup('asyncrun_airline', {
  {'User', 'AirlineAfterInit', ':lua asyncrun_airline_init()'},
})
