local plugin = require 'lualine'
local base16 = require 'plugins.base16'

local theme = 'auto' -- default for plugin

if (base16.type == 'cterm' or base16.type == 'default') then
  -- cterm colors, which lualine does not supported
  -- so fall back to a known theme within lualine
  -- (normally occurs if termguicolors is not set)
  theme = 'material'
else
  local customThemeInputs = {
    bg = base16.colors.base01,
    alt_bg = base16.colors.base02,
    dark_fg = base16.colors.base03,
    fg = base16.colors.base04,
    light_fg = base16.colors.base05,
    normal = base16.colors.base0D,
    insert = base16.colors.base0B,
    visual = base16.colors.base0E,
    replace = base16.colors.base09,
  }

  -- lualine has it's own theming and the default 'auto' attempts
  -- to load base16 based on different plugins, which is error prone
  local function createTheme(colors)
    return {
      normal = {
        a = { fg = colors.bg, bg = colors.normal },
        b = { fg = colors.light_fg, bg = colors.alt_bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.replace },
        b = { fg = colors.light_fg, bg = colors.alt_bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.insert },
        b = { fg = colors.light_fg, bg = colors.alt_bg },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.visual },
        b = { fg = colors.light_fg, bg = colors.alt_bg },
      },
      inactive = {
        a = { fg = colors.dark_fg, bg = colors.bg },
        b = { fg = colors.dark_fg, bg = colors.bg },
        c = { fg = colors.dark_fg, bg = colors.bg },
      },
    }
  end

  ---@diagnostic disable-next-line: cast-local-type
  theme = createTheme(customThemeInputs)
end


plugin.setup {
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1
      }
    }
  },
  options = {
    theme = theme,
    globalstatus = true
  }
}
