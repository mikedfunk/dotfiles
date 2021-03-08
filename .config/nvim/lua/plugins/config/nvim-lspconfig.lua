-- vim: set fdm=marker:

local helpers = require'helpers'
local eslint = require'plugins.config.nvim-lspconfig.diagnosticls.eslint'
local prettier = require'plugins.config.nvim-lspconfig.diagnosticls.prettier'
local phpcs = require'plugins.config.nvim-lspconfig.diagnosticls.phpcs'
local phpstan = require'plugins.config.nvim-lspconfig.diagnosticls.phpstan'
local intelephense = require'plugins.config.nvim-lspconfig.intelephense'
local lspconfig = require'lspconfig'
local create_augroup = require'helpers'.create_augroup
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
local is_plugin_installed = helpers.is_plugin_installed
local tbl_isempty, tbl_islist, lsp, getenv, expand, split = vim.tbl_isempty, vim.tbl_islist, vim.lsp, vim.fn.getenv, vim.fn.expand, vim.split
local nvim_multiline_command = lspconfig.util.nvim_multiline_command

if not is_plugin_installed('nvim-lspconfig') then
  return
end

local lspconfig = require'lspconfig'

-- enable debug logging {{{
-- vim.lsp.set_log_level("debug")
-- you can open the log with :lua vim.cmd('e'..vim.lsp.get_log_path())
-- }}}

-- peek_definition {{{
local function preview_location_callback(_, method, result)
  if result == nil or tbl_isempty(result) then
    if not lsp.log == nil then
      lsp.log.info(method, 'No location found')
    end
    return nil
  end

  if tbl_islist(result) then
    lsp.util.preview_location(result[1])
  else
    lsp.util.preview_location(result)
  end
end

-- intentionally global
-- preview the definition under the cursor
function peek_definition()
  local params = lsp.util.make_position_params()
  return lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end
-- }}}

-- set lsp mappings - used in on_attach {{{
-- https://rishabhrd.github.io/jekyll/update/2020/09/19/nvim_lsp_config.html
local function set_lsp_mappings(client, bufnr)
  local mappings = {
    {mode = 'n', keys = 'gd', action = '<cmd>lua vim.lsp.buf.declaration()<CR>'}, -- jump to the declaration of the symbol under the cursor E.g. class property
    {mode = 'n', keys = 'K', action = '<cmd>lua vim.lsp.buf.hover()<cr>'}, -- show details of the symbol under the cursor in a popup
    {mode = 'n', keys = 'gi', action = '<cmd>lua vim.lsp.buf.implementation()<cr>'}, -- when the cursor is over an interface, jump to the implementation (I assume if multiple you'll get an echo and a prompt for number)
    {mode = 'n', keys = '<c-k>', action = '<c-o><cmd>lua vim.lsp.buf.signature_help()<cr>'}, -- if you are in the parens for a function call press this to show a popup with help for the param you are currently on
    {mode = 'i', keys = '<c-k>', action = '<c-o><cmd>lua vim.lsp.buf.signature_help()<cr>'}, -- if you are in the parens for a function call press this to show a popup with help for the param you are currently on

    {mode = 'n', keys = '<leader>wa', action = '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>'}, -- add a folder to the _lsp_ workspace so it can be completed, etc.
    {mode = 'n', keys = '<leader>wr', action = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>'},
    {mode = 'n', keys = '<leader>wl', action = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'},
    {mode = 'n', keys = '<leader>td', action = '<cmd>lua vim.lsp.buf.type_definition()<cr>'}, -- e.g. if you have a var with an instance of a class, go to the _class_ definition instead of the variable definition
    -- {mode = 'n', keys = '1gD', action = '<cmd>lua vim.lsp.buf.type_definition()<cr>'},
    {mode = 'n', keys = '<leader>rr', action = '<cmd>lua vim.lsp.buf.rename()<CR>'}, -- rename the symbol under the cursor, prompts for a new name
    -- {mode = 'n', keys = 'gr', action = '<cmd>lua vim.lsp.buf.references()<cr>'}, -- populate a quickfix with lines in the workspace that have references to the symbol under the cursor, then open it
    -- {mode = 'n', keys = '<leader>ee', action = '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>'}, -- not working 2021-01-11
    {mode = 'n', keys = '[d', action = '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'}, -- go to the previous diagnostic message
    {mode = 'n', keys = ']d', action = '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'}, -- go to the next diagnostic message
    {mode = 'n', keys = '<leader>dq', action = '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'}, -- populate any lsp diagnostics into the loclist and open the loclist

    {mode = 'n', keys = '<leader>cc', action = '<cmd>lua vim.lsp.buf.code_action()<cr>'}, -- open a "menu" with available code actions
    {mode = 'n', keys = '<c-]>', action = '<cmd>lua vim.lsp.buf.definition()<cr>'}, -- jump to the symbol under the cursor
    {mode = 'n', keys = '<leader><c-]>', action = 'mz:tabe %<cr>`z<cmd>lua vim.lsp.buf.definition()<cr>'}, -- jump to the symbol under the cursor in a new tab
    {mode = 'n', keys = '<c-w><c-]>', action = '<cmd>vsp<cr><cmd>lua vim.lsp.buf.definition()<cr>'}, -- jump to the symbol under the cursor in a vertical split
    {mode = 'n', keys = '<c-w>}', action = '<cmd>lua peek_definition()<cr>'}, -- open a popup with the definition of the method under the cursor
    {mode = 'n', keys = 'g0', action = '<cmd>lua vim.lsp.buf.document_symbol()<cr>'}, -- open a quickfix with all symbols in the current file e.g. class, variable, method, etc.
    {mode = 'n', keys = 'gW', action = '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>'}, -- search for the typed workspace symbol
    {mode = 'n', keys = '<leader>tt', action = '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>'}, -- search for the typed workspace symbol
    -- {mode = 'n', keys = '<leader>ai', action = '<cmd>lua vim.lsp.buf.incoming_calls()<CR>'}, -- not working 2021-01-11
    -- {mode = 'n', keys = '<leader>ao', action = '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>'}, -- not working 2021-01-11
  }

  for _, mapping in ipairs(mappings) do
    local mode, keys, action = mapping.mode, mapping.keys, mapping.action
    nvim_buf_set_keymap(bufnr, mode, keys, action, {noremap = true, silent = true})
  end

  -- Set some keybinds conditional on server capabilities
  local opts = {noremap = true, silent = true}
  if client.resolved_capabilities.document_formatting then
    nvim_buf_set_keymap(bufnr, 'n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    nvim_buf_set_keymap(bufnr, 'n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- nvim_multiline_command [[
  --   :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
  --   :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
  --   :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  -- ]]

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    -- create_augroup('lsp_document_highlight', {
    --   {'CursorHold', '<buffer> lua vim.lsp.buf.document_highlight()'},
    --   {'CursorMoved', '<buffer> lua vim.lsp.buf.clear_references()'},
    -- })
  end
end
-- }}}

-- on_attach handler {{{
local function on_attach(client, bufnr)
  -- Set the omnifunc for this buffer
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  set_lsp_mappings(client, bufnr)

  if is_plugin_installed('completion-nvim') then
    require'completion'.on_attach(client, bufnr)
  end
end
-- }}}

-- intelephense lsp {{{
-- https://github.com/bmewburn/intelephense-docs/blob/master/installation.md
lspconfig.intelephense.setup{
  settings = intelephense,
  on_attach = on_attach
}
-- }}}

-- diagnosticls lsp {{{
-- TODO this entire lsp doesn't seem to be working yet
-- also this isn't present in all asdf node versions... gotta figure out what to do about that
-- https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
-- lspconfig.diagnosticls.setup{
--   filetypes = {
--       'javascript',
--       'javascript.jsx',
--       'typescript',
--       'typescript.tsx',
--       'php',
--   },
--   init_options = {
--     filetypes = {
--       javascript = 'eslint',
--       ["javascript.jsx"] = 'eslint',
--       typescript = 'eslint',
--       ["typescript.tsx"] = 'eslint',
--       php = 'phpcs',
--       php = 'phpstan',
--     },
--     formatFiletypes = {
--       javascript = 'prettier',
--       ["javascript.jsx"] = 'prettier',
--       typescript = 'prettier',
--       ["typescript.tsx"] = 'prettier',
--     },
--     linters = {
--       eslint = eslint,
--       phpcs = phpcs,
--       phpstan = phpstan,
--       -- TODO php -l
--       -- TODO phpmd
--       -- TODO php-cs-fixer
--       -- TODO easy-coding-standard
--     },
--     formatters = {
--       prettier = prettier,
--       -- TODO phpcbf (don't forget phpcbf-helper.sh)
--       -- TODO php-cs-fixer
--       -- TODO does phpmd have a fixer?
--     },
--   },
--   on_attach = on_attach,
-- }
-- }}}

-- sumneko (lua) lsp {{{
-- this takes a ton of CPU so I'm only going to enable it when I need it.

-- lspconfig.sumneko_lua.setup{
--   cmd = {
--     -- this was suggested in the output of :LspInstall sumneko_lua
--     -- see :LspInstallInfo sumneko_lua
--     getenv('HOME') .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
--     "-E",
--     getenv('HOME') .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua"
--   },
--   settings = {
--     Lua = {
--       -- https://rishabhrd.github.io/jekyll/update/2020/09/19/nvim_lsp_config.html
--       runtime = {version = 'LuaJIT', path = split(package.path, ';')},
--       diagnostics = {
--         globals = {
--           'vim',
--           'use',
--         },
--       },
--       workspace = {
--         library = {
--           [expand('$VIMRUNTIME/lua')] = true,
--         },
--       },
--     },
--   },
--   on_attach = on_attach,
-- }
-- }}}

-- lspconfig.solargraph.setup{on_attach = on_attach}
