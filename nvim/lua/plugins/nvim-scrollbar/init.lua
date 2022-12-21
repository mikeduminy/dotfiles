local plugin = require 'scrollbar'
local b16 = require 'plugins.base16'
local colorType = b16.getType()
local colors = b16.getColors()

local config = {
  handle = {
    hide_if_all_visible = true,
  },
  excluded_filetypes = {
    'dashboard',
    'prompt',
    'TelescopePrompt',
    'neo-tree',
  },
}
if (colorType == 'gui') then
  config.marks = {
    Cursor = { color = colors.base01 },
    Search = { color = colors.base02 },
    Error = { color = colors.base0E },
    Warn = { color = colors.base0C },
    Info = { color = colors.base07 },
    Hint = { color = colors.base03 },
    Misc = { color = colors.base01 },
    GitAdd = { color = colors.base0B },
    GitChange = { color = colors.base0E },
    GitDelete = { color = colors.base08 },
  }
end

if (colorType == 'cterm') then
  config.handle.cterm = colors.base04
  config.marks = {
    Cursor = { cterm = colors.base01 },
    Search = { cterm = colors.base02 },
    Error = { cterm = colors.base0E },
    Warn = { cterm = colors.base0C },
    Info = { cterm = colors.base07 },
    Hint = { cterm = colors.base03 },
    Misc = { cterm = colors.base01 },
    GitAdd = { cterm = colors.base0B },
    GitChange = { cterm = colors.base0E },
    GitDelete = { cterm = colors.base08 },
  }
end

plugin.setup(config)
