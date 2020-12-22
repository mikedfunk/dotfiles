local g = vim.g
local nvim_set_keymap = vim.api.nvim_set_keymap

-- g['$FZF_DEFAULT_COMMAND'] = 'ag --files-with-matches --skip-vcs-ignores -g ""'
local fzf_action = {}
fzf_action['ctrl-t'] = 'tab split'
fzf_action['ctrl-x'] = 'split'
fzf_action['ctrl-v'] = 'vsplit'
g['fzf_action'] = fzf_action
g['fzf_buffers_jump'] = 1

nvim_set_keymap('n', '<leader>ag', ':Ag<cr>', {noremap = true}) -- can be replaced with telescope
nvim_set_keymap('n', '<leader>ff', ':Files<cr>', {noremap = true}) -- can be replaced with telescope
-- nvim_set_keymap('n', '<leader>tt', ':Tags<cr>', {noremap = true}) -- replaced with lsp workspace symbols
nvim_set_keymap('n', '<leader>hh', ':Helptags<cr>', {noremap = true}) -- can be replaced with telescope
