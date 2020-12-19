local helpers = require'helpers'
local g, cmd, create_augroup, is_plugin_installed = vim.g, vim.cmd, helpers.create_augroup, helpers.is_plugin_installed

g['vdebug_options'] = {
  timeout = 30,
  watch_window_style = 'compact',
  continuous_mode = 1,
  -- debug_file = '/tmp/xdebug.log',
  simplified_status = 1,
}

g['vdebug_keymap'] = {eval_visual = '<leader>ev'}

-- intentionally global
function fix_vdebug_highlights()
  cmd('highlight DbgBreakptLine term=reverse ctermfg=Black ctermbg=Green guifg=#000000 guibg=#00ff00')
  cmd('highlight DbgBreakptSign term=reverse ctermfg=Black ctermbg=Green guifg=#000000 guibg=#00ff00')
  cmd('highlight DbgCurrentLine term=reverse ctermfg=White ctermbg=Red guifg=#ffffff guibg=#ff0000')
  cmd('highlight DbgCurrentSign term=reverse ctermfg=White ctermbg=Red guifg=#ffffff guibg=#ff0000')
end

create_augroup('fix_vdebug_highlights', {
    {'FileType', 'php', 'lua fix_vdebug_highlights()'},
    {'ColorScheme', '*', 'lua fix_vdebug_highlights()'},
})

create_augroup('vdebug_watch_panel_larger', {
    {'Bufenter', 'DebuggerWatch', 'resize 999'},
    {'Bufenter', 'DebuggerStack', 'resize 999'},
})

if not is_plugin_installed('vdebug') or not is_plugin_installed('Repeatable.vim') then
  return
end

local function open_vdebug_trees()
  cmd("silent! " .. g['vdebug_options']["marker_closed_tree"] .. "/normal <cr><cr>")
end

local function close_vdebug_trees()
  cmd("silent! " .. g['vdebug_options']["marker_open_tree"] .. "/normal <cr><cr>")
end

-- TODO not a command?
-- cmd('Repeatable nnoremap <leader>v+ :silent! lua open_vdebug_trees()<cr>')
-- cmd('Repeatable nnoremap <leader>v- :silent! lua close_vdebug_trees()<cr>')
cmd('nnoremap <leader>v+ :silent! lua open_vdebug_trees()<cr>')
cmd('nnoremap <leader>v- :silent! lua close_vdebug_trees()<cr>')
