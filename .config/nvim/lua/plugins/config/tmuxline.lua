local is_plugin_installed = require'helpers'.is_plugin_installed
local g, cmd = vim.g, vim.cmd

g['tmuxline_preset'] = {
     a = {'🏠 #S'}, -- session name
     c = {
       '#{cpu_fg_color}#{cpu_icon}#[fg=default] #{ram_fg_color}#{ram_icon}#[fg=default] #{battery_color_charge_fg}#{battery_icon_charge}#[fg=default]', -- cpu, ram, battery
       '#(~/.support/docker-status.sh)',
     },
     win = {'#I', '#W'}, -- unselected tab
     cwin = {'#I', '#W#F'}, -- current tab
     x = {"#(TZ=Etc/UTC date '+%%R UTC')"}, -- UTC time
     y = {'%l:%M %p'}, -- local time
     z = {'%a', '%b %d'}, -- local date
}

if is_plugin_installed('tmuxline.vim') then
    -- apply tmuxline settings and snapshot to file
    cmd('command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline.conf')
end
