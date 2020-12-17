local nvim_set_keymap = vim.api.nvim_set_keymap

nvim_set_keymap('n', '<leader>bi', ':PackerInstall<CR>', {noremap = true})
nvim_set_keymap('n', '<leader>bc', ':PackerClean<CR>', {noremap = true})
nvim_set_keymap('n', '<leader>bu', ':PackerSync<CR>', {noremap = true})
