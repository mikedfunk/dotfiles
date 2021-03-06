local is_plugin_installed = require'helpers'.is_plugin_installed

if not is_plugin_installed('nvim-treesitter') then
  return
end

require'nvim-treesitter.configs'.setup{
  ensure_installed = {'javascript', 'php', 'lua', 'json', 'css'},
  -- highlight = {enable = true}, -- in php this is ugly and it removes a lot of my highlighting enhancements
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      },
    },
  },
}

-- full example:
--
-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = { "javascript", "php" },
--   highlight = { enable = true },
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = "gnn",
--       node_incremental = "grn",
--       scope_incremental = "grc",
--       node_decremental = "grm"
--     },
--   },
--   refactor = {
--     highlight_definitions = { enable = true },
--     highlight_current_scope = { enable = true },
--     smart_rename = {
--       enable = true,
--       keymaps = { smart_rename = "grr" }
--     },
--     navigation = {
--       enable = true,
--       keymaps = {
--         goto_definition = "gnd",
--         list_definitions = "gnD",
--         goto_next_usage = "<a-*>",
--         goto_previous_usage = "<a-#>"
--       },
--     },
--   },
--   textobjects = {
--     select = {
--       enable = true,
--       keymaps = {
--         ["af"] = "@function.outer",
--         ["if"] = "@function.inner",
--         ["ac"] = "@class.outer",
--         ["ic"] = "@class.inner"
--       },
--     },
--     move = {
--       enable = true,
--       goto_next_start = {
--         ["]m"] = "@function.outer",
--         ["]]"] = "@class.outer"
--       },
--       goto_next_end = {
--         ["]M"] = "@function.outer",
--         ["]["] = "@class.outer"
--       },
--       goto_previous_start = {
--         ["[m"] = "@function.outer",
--         ["[["] = "@class.outer"
--       },
--       goto_previous_end = {
--         ["[M"] = "@function.outer",
--         ["[]"] = "@class.outer"
--       }
--     }
--   }
-- }
