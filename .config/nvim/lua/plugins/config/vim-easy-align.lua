local nvim_set_keymap = vim.api.nvim_set_keymap

nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {noremap = true}) -- Start interactive EasyAlign in visual mode (e.g. vipga)
nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {noremap = true}) -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
