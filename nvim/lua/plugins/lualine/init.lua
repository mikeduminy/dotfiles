local plugin = require 'lualine'
local base16 = require 'plugins.base16'

local theme = 'auto' -- default for plugin

-- if (base16.type == 'cterm' or base16.type == 'default') then
--   -- cterm colors, which lualine does not supported
--   -- so fall back to a known theme within lualine
--   -- (normally occurs if termguicolors is not set)
--   theme = 'codedark'
-- else

local colors = base16.getColors()

local customThemeInputs = {
  bg = colors.base01,
  alt_bg = colors.base02,
  dark_fg = colors.base03,
  fg = colors.base04,
  light_fg = colors.base05,
  normal = colors.base0D,
  insert = colors.base0B,
  visual = colors.base0E,
  replace = colors.base09,
}

-- lualine has it's own theming and the default 'auto' attempts
-- to load base16 based on different plugins, which is error prone
local function createTheme(input)
  return {
    normal = {
      a = { fg = input.bg, bg = input.normal },
      b = { fg = input.light_fg, bg = input.alt_bg },
      c = { fg = input.fg, bg = input.bg },
    },
    insert = {
      a = { fg = input.bg, bg = input.insert },
      b = { fg = input.light_fg, bg = input.alt_bg },
    },
    visual = {
      a = { fg = input.bg, bg = input.visual },
      b = { fg = input.light_fg, bg = input.alt_bg },
    },
    replace = {
      a = { fg = input.bg, bg = input.replace },
      b = { fg = input.light_fg, bg = input.alt_bg },
    },
    command = {
      a = { bg = input.green, fg = input.black, gui = 'bold' },
      b = { bg = input.lightgray, fg = input.white },
      c = { bg = input.inactivegray, fg = input.black }
    },
    inactive = {
      a = { fg = input.dark_fg, bg = input.bg },
      b = { fg = input.dark_fg, bg = input.bg },
      c = { fg = input.dark_fg, bg = input.bg },
    },
  }
end

theme = createTheme(customThemeInputs)

vim.opt.laststatus = 3


plugin.setup {
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'tabs' },
    lualine_x = { 'filetype' },
    lualine_z = { 'location' }
  },
  winbar = {
    lualine_a = { 'diagnostics' },
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = { 'diagnostics' },
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {},
    lualine_z = {}
  },
  options = {
    theme = theme,
    globalstatus = true,
    disabled_filetypes = {
      'neo-tree', 'fugitive', ''
    },
    ignore_focus = {
      'neo-tree', 'fugitive', ''
    }
  },
  extensions = { 'neo-tree' }
}
