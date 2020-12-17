local helpers = require'helpers'
local is_plugin_installed, create_augroup = helpers.is_plugin_installed, helpers.create_augroup

if is_plugin_installed('vim-git') then
  -- intentionally global
  function vim_git_mappings()
    nvim_buf_set_keymap(0, 'n', 'I', ':Pick<cr>', {noremap = true, silent = true})
    nvim_buf_set_keymap(0, 'n', 'R', ':Reword<cr>', {noremap = true, silent = true})
    nvim_buf_set_keymap(0, 'n', 'E', ':Edit<cr>', {noremap = true, silent = true})
    nvim_buf_set_keymap(0, 'n', 'S', ':Squash<cr>', {noremap = true, silent = true})
    nvim_buf_set_keymap(0, 'n', 'F', ':Fixup<cr>', {noremap = true, silent = true})
    nvim_buf_set_keymap(0, 'n', 'D', ':Drop<cr>', {noremap = true, silent = true})
  end

  create_augroup('vim_git', {
    {'FileType', 'gitrebase', 'lua vim_git_mappings()'},
  })
end
