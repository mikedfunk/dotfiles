local helpers = require'helpers'
local create_augroup, is_plugin_installed = helpers.create_augroup, helpers.is_plugin_installed
local g, getenv, call = vim.g, vim.fn.getenv, vim.call

-- g['airline#extensions#obsession#enabled'] = 1
g['airline#extensions#ale#error_symbol'] = 'Errors:' -- default: E
g['airline#extensions#ale#show_line_numbers'] = 0
g['airline#extensions#ale#warning_symbol'] = 'Warnings:' -- default: W
g['airline#extensions#branch#format'] = 1 -- feature/foo -> foo
g['airline#extensions#fugitiveline#enabled'] = 1
g['airline#extensions#fzf#enabled'] = 1
g['airline#extensions#gutentags#enabled'] = 1
g['airline#extensions#nvimlsp#enabled'] = 0 -- overlaps with ale
g['airline#extensions#searchcount#enabled'] = 1
g['airline#extensions#tabline#close_symbol'] = '✕' -- configure symbol used to represent close button
g['airline#extensions#tabline#enabled'] = 1 -- advanced tabline
g['airline#extensions#tabline#show_buffers'] = 0 -- shows buffers when no tabs
g['airline#extensions#tabline#show_splits'] = 0 -- hide the annoying windows-in-tabs on the right side. This has somehow ended up with a ton of [No Name] tabs. It crowds out the actual tab list.
g['airline#extensions#tabline#show_tab_count'] = 0 -- hide tab count on right
g['airline#extensions#tabline#show_tab_type'] = 0 -- right side says either 'buffers' or 'tabs'
g['airline#extensions#tabline#tab_nr_type'] = 1 -- tab number
g['airline#extensions#tagbar#enabled'] = 0 -- cool but slows down php
g['airline#extensions#tmuxline#enabled'] = 0
g['airline#extensions#tmuxline#snapshot_file'] = getenv('HOME') .. '/.tmuxline.conf'
g['airline#extensions#vista#enabled'] = 1
g['airline#extensions#whitespace#enabled'] = 1 -- show whitespace warnings
g['airline#extensions#wordcount#enabled'] = 0
g['airline_highlighting_cache'] = 1 -- cache syntax highlighting for better performance
g['airline_powerline_fonts'] = 1 -- airline use cool powerline symbols (this also makes vista.vim use powerline symbols)
g['airline_theme'] = 'base16'

if not is_plugin_installed('vim-airline') or not is_plugin_installed('asyncrun.vim') then
  return
end

-- intentionally global
function asyncrun_airline_init()
  g['airline_section_z'] = call('airline#section#create_right', {'%{g:asyncrun_status} ' .. g['airline_section_z']})
end

create_augroup('asyncrun_airline', {
  {'User', 'AirlineAfterInit', ':lua asyncrun_airline_init()'},
})
