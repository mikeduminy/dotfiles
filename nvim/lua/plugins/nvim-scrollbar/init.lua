local plugin = require 'scrollbar'
local b16 = require 'plugins.base16'

local config = {
  handle = {
    hide_if_all_visible = false,
  },
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
    "neo-tree",
  },
}

if (b16.type == 'default') then
  config.handle.color = b16.colors.base00
end

plugin.setup(config)
