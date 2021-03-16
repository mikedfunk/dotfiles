local helpers = require'helpers'
local is_plugin_installed, create_augroup = helpers.is_plugin_installed, helpers.create_augroup

if not is_plugin_installed('nvim-lightbulb') then
  return
end

-- intentionally global
function update_nvim_lightbulb()
  require'nvim-lightbulb'.update_lightbulb {
    sign = {
      enabled = false, -- TODO why isn't this working
    },
    float = {
      enabled = false,
    },
    virtual_text = {
      enabled = true,
    }
  }
end

-- create_augroup('update_nvim_lightbulb', {
--   {"CursorHold", "*", "lua update_nvim_lightbulb()"},
--   {"CursorHoldI", "*", "lua update_nvim_lightbulb()"},
-- })

-- vim.fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl="", numhl="" })
