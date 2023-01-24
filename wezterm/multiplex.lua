local wezterm = require 'wezterm'

local function is_vi_process(pane)
  return pane:get_foreground_process_name():find 'n?vim' ~= nil
end

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
  if is_vi_process(pane) then
    window:perform_action(wezterm.action.SendKey { key = vim_direction, mods = 'CTRL' }, pane)
  else
    window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on('ActivatePaneDirection-right', function(window, pane)
  conditional_activate_pane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
  conditional_activate_pane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
  conditional_activate_pane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
  conditional_activate_pane(window, pane, 'Down', 'j')
end)
