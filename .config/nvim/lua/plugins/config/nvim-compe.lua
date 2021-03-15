local is_plugin_installed = require'helpers'.is_plugin_installed
local nvim_set_keymap = vim.api.nvim_set_keymap

if not is_plugin_installed('nvim-compe') then
  return
end

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = false;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = false;
    snippets_nvim = false;
    treesitter = false;
  }
};

nvim_set_keymap('i', '<c-space>', 'compe#complete()', {noremap = true, expr = true})

-- conflicts with autopairs
-- nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', {noremap = true, expr = true, silent = true})

nvim_set_keymap('i', '<c-e>', "compe#close('<c-e>')", {noremap = true, expr = true, silent = true})
nvim_set_keymap('i', '<c-f>', "scroll({ 'delta': +4 })", {noremap = true, expr = true, silent = true})
nvim_set_keymap('i', '<c-d>', "scroll({ 'delta': -4 })", {noremap = true, expr = true, silent = true})
