-- vim: set fdm=marker:

local helpers = require'helpers'
local lspconfig = require'lspconfig'
local eslint = require'plugins.config.nvim-lspconfig.diagnosticls.eslint'
local prettier = require'plugins.config.nvim-lspconfig.diagnosticls.prettier'
local phpcs = require'plugins.config.nvim-lspconfig.diagnosticls.phpcs'
local phpstan = require'plugins.config.nvim-lspconfig.diagnosticls.phpstan'
local intelephense = require'plugins.config.nvim-lspconfig.intelephense'
local is_plugin_installed = helpers.is_plugin_installed
local tbl_isempty, tbl_islist, lsp, getenv = vim.tbl_isempty, vim.tbl_islist, vim.lsp, vim.fn.getenv

if is_plugin_installed('nvim-lspconfig') then

  -- peek_definition {{{
  local function preview_location_callback(_, method, result)
    if result == nil or tbl_isempty(result) then
      lsp.log.info(method, 'No location found')
      return nil
    end

    if tbl_islist(result) then
      lsp.util.preview_location(result[1])
    else
      lsp.util.preview_location(result)
    end
  end

  -- intentionally global! preview the definition under the cursor
  function peek_definition()
    local params = lsp.util.make_position_params()
    return lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
  end
  -- }}}

  -- on_attach handler {{{
  -- intentionally global! shared on_attach lua handler for nvim lsp
  -- function on_attach(client, bufnr)
  --   if is_plugin_installed('completion-nvim') then
  --     require'completion'.on_attach(client, bufnr)
  --   end
  -- end
  -- }}}

  -- intelephense lsp {{{
  -- https://github.com/bmewburn/intelephense-docs/blob/master/installation.md
  lspconfig.intelephense.setup{settings = intelephense}
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
        ["typescript.tsx"] = 'prettier'
      },
      linters = {
        eslint = eslint,
        phpcs = phpcs,
        phpstan = phpstan,
        -- TODO php -l
        -- TODO phpmd
      },
      formatters = {
        prettier = prettier
        -- TODO phpcbf (don't forget phpcbf-helper.sh)
        -- TODO php-cs-fixer
        -- TODO does phpmd have a fixer?
      }
    }
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
  --       diagnostics = {
  --         globals = {
  --           'vim',
  --           'use',
  --         },
  --       },
  --       workspace = {
  --         library = {
  --           ['$VIMRUNTIME/lua'] = true,
  --         }
  --       }
  --     },
  --   },
  -- }
  -- }}}

  lspconfig.solargraph.setup{}
end
