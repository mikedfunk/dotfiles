local getenv, isdirectory, mkdir, cmd = vim.fn.getenv, vim.fn.isdirectory, vim.fn.makedir, vim.cmd

local dir_list = {
  backup = 'backupdir',
  views = 'viewdir',
  swap = 'directory',
  undo = 'undodir',
}

local common_dir = getenv('HOME') .. '/.config/nvim/'

for dir_name, setting_name in pairs(dir_list) do
  local dir = common_dir .. dir_name .. '/'

  if isdirectory(dir) == 0 then
    mkdir(dir)
  end

  if isdirectory(dir) == 0 then
    cmd('echo "Warning: Unable to create backup directory: ' .. dir .. '"')
    cmd('echo "Try: mkdir -p ' .. dir .. '"')
  else
    cmd('set ' .. setting_name .. '=' .. dir)
  end
end
