local wezterm = require 'wezterm'

return {
  font = wezterm.font 'JetBrains Mono',
  keys = {
    {
      key = 'w',
      mods = 'CMD',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
  },
  scrollback_lines = 6000, -- default is 3500
  switch_to_last_active_tab_when_closing_tab = true, -- default is false
}

-- Hot to upgrade wezterm
-- brew upgrade --cask wez/wezterm/wezterm
