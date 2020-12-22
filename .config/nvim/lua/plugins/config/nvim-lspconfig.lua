-- vim: set fdm=marker:

local helpers = require'helpers'
local eslint = require'plugins.config.nvim-lspconfig.diagnosticls.eslint'
local prettier = require'plugins.config.nvim-lspconfig.diagnosticls.prettier'
local phpcs = require'plugins.config.nvim-lspconfig.diagnosticls.phpcs'
local phpstan = require'plugins.config.nvim-lspconfig.diagnosticls.phpstan'
local intelephense = require'plugins.config.nvim-lspconfig.intelephense'
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
local is_plugin_installed = helpers.is_plugin_installed
local tbl_isempty, tbl_islist, lsp, getenv, expand, split = vim.tbl_isempty, vim.tbl_islist, vim.lsp, vim.fn.getenv, vim.fn.expand, vim.split

if not is_plugin_installed('nvim-lspconfig') then
  return
end

local lspconfig = require'lspconfig'

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
local function set_lsp_mappings(bufnr)
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
    },
    {
      mode = 'n',
      keys = '<leader>ee',
      action = '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>',
    },
    {
      mode = 'n',
      keys = '<leader>rr',
      action = '<cmd>lua vim.lsp.buf.rename()<CR>',
    },
    {
      mode = 'n',
      keys = '<leader>=',
      action = '<cmd>lua vim.lsp.buf.formatting()<CR>',
    },
    {
      mode = 'n',
      keys = '<leader>ai',
      action = '<cmd>lua vim.lsp.buf.incoming_calls()<CR>',
    },
    {
      mode = 'n',
      keys = '<leader>ao',
      action = '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>',
    },
  }

  for _, mapping in ipairs(mappings) do
    local mode, keys, action = mapping.mode, mapping.keys, mapping.action
    nvim_buf_set_keymap(bufnr, mode, keys, action, {noremap = true, silent = true})
  end
end
-- }}}

-- on_attach handler {{{
local function on_attach(client, bufnr)
  -- Set the omnifunc for this buffer
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  set_lsp_mappings(bufnr)

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
-- https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
lspconfig.diagnosticls.setup{
  filetypes = {
      'javascript',
      'javascript.jsx',
      'typescript',
      'typescript.tsx',
      'php',
  },
  init_options = {
    filetypes = {
      javascript = 'eslint',
      ["javascript.jsx"] = 'eslint',
      typescript = 'eslint',
      ["typescript.tsx"] = 'eslint',
      php = 'phpcs',
      php = 'phpstan',
    },
    formatFiletypes = {
      javascript = 'prettier',
      ["javascript.jsx"] = 'prettier',
      typescript = 'prettier',
      ["typescript.tsx"] = 'prettier',
    },
    linters = {
      eslint = eslint,
      phpcs = phpcs,
      phpstan = phpstan,
      -- TODO php -l
      -- TODO phpmd
      -- TODO php-cs-fixer
      -- TODO easy-coding-standard
    },
    formatters = {
      prettier = prettier,
      -- TODO phpcbf (don't forget phpcbf-helper.sh)
      -- TODO php-cs-fixer
      -- TODO does phpmd have a fixer?
    },
  },
  on_attach = on_attach,
}
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
