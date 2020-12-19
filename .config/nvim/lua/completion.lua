-- vim; set fdm=marker:
local helpers = require'helpers'
local create_augroup, minus_equals, plus_equals = helpers.create_augroup, helpers.minus_equals, helpers.plus_equals
local o, nvim_set_keymap, nvim_set_keymap, nvim_buf_set_keymap = vim.o, vim.api.nvim_set_keymap, vim.api.nvim_set_keymap, vim.api.nvim_buf_set_keymap

-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made (TODO not working for some reason)
-- noselect: Do not select, force user to select one from the menu
o.completeopt = table.concat({'menuone', 'noinsert', 'noselect'}, ',')

create_augroup('omnifunc_set_scss', {
  {'FileType', 'scss', 'setlocal omnifunc=csscomplete#CompleteCSS'},
})

create_augroup('omnifunc_set', {
  {'FileType', '*', 'if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif'},
})

local wildignore_patterns = {
  '*.bmp',
  '*.gif',
  '*.ico',
  '*.jpg',
  '*.png',
  '*.ico',
  '*.pdf',
  '*.psd',
  'node_modules/*',
  '.git/*',
  'Session.vim',
}
for k,wildignore_pattern in pairs(wildignore_patterns) do
  o.wildignore = plus_equals(o.wildignore, wildignore_pattern)
end

o.wildoptions = plus_equals(o.wildoptions, 'tagfile') -- When using CTRL-D to list matching tags, the kind of tag and the file of the tag is listed.	Only one match is displayed per line.
o.wildoptions = plus_equals(o.wildoptions, 'pum') -- turn the wildmenu into a popup menu

-- tab completion
nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', {noremap = true, expr = true})
nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', {noremap = true, expr = true})

-- set vim lsp omnifunc for filetypes that should have it {{{
local lsp_filetypes = {
  'php',
  'javascript',
  'ruby',
  'lua',
  'python',
}
local autocmds = {}
for _, filetype in ipairs(lsp_filetypes) do
  table.insert(autocmds, {'FileType', filetype, 'setlocal omnifunc=v:lua.vim.lsp.omnifunc'})
end
create_augroup('omnifunc_set_lsp', autocmds)
-- }}}

-- show hover details on cursorhold {{{
-- create_augroup('php_hover_def', {
--   {'CursorHold', '*.php', 'silent! lua vim.lsp.buf.hover()'}
-- })
-- }}}

-- mappings {{{
-- intentionally global
function set_php_lsp_mappings()
  local mappings = {
    {
      mode = 'n',
      keys = '<leader>cc',
      action = '<cmd>lua vim.lsp.buf.code_action()<cr>',
    },
    {
      mode = 'n',
      keys = '<c-]>',
      action = '<cmd>lua vim.lsp.buf.definition()<cr>',
    },
    {
      mode = 'n',
      keys = '<leader><c-]>',
      action = 'mz:tabe %<cr>`z<cmd>lua vim.lsp.buf.definition()<cr>',
    },
    {
      mode = 'n',
      keys = '<c-w><c-]>',
      action = '<cmd>vsp<cr><cmd>lua vim.lsp.buf.definition()<cr>',
    },
    {
      mode = 'n',
      keys = '<c-w>}',
      action = '<cmd>lua peek_definition()<cr>',
    },
    {
      mode = 'n',
      keys = 'gD',
      action = '<cmd>lua vim.lsp.buf.implementation()<cr>',
    },
    {
      mode = 'n',
      keys = 'K',
      action = '<cmd>lua vim.lsp.buf.hover()<cr>',
    },
    {
      mode = 'n',
      keys = '<c-k>',
      action = '<cmd>lua vim.lsp.buf.hover()<cr>',
    },
    {
      mode = 'i',
      keys = '<c-k>',
      action = '<c-o><cmd>lua vim.lsp.buf.signature_help()<cr>',
    },
    {
      mode = 'n',
      keys = '1gD',
      action = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
    },
    {
      mode = 'n',
      keys = 'gr',
      action = '<cmd>lua vim.lsp.buf.references()<cr>',
    },
    {
      mode = 'n',
      keys = 'g0',
      action = '<cmd>lua vim.lsp.buf.document_symbol()<cr>',
    },
    {
      mode = 'n',
      keys = 'gW',
      action = '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>',
    },
    {
      mode = 'n',
      keys = 'gd',
      action = '<cmd>lua vim.lsp.buf.declaration()<CR>',
    }
  }

  for _, mapping in ipairs(mappings) do
    local mode, keys, action = mapping.mode, mapping.keys, mapping.action
    nvim_buf_set_keymap(0, mode, keys, action, {noremap = true, silent = true})
  end
end

create_augroup('set_php_lsp_mappings', {
  {'FileType', 'php', 'lua set_php_lsp_mappings()'}
})
-- }}}
