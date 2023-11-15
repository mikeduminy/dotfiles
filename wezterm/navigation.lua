local wezterm = require 'wezterm'

--- @param pane _.wezterm.Pane
--- @return boolean
local function is_vi_process(pane)
  return pane:get_foreground_process_name():find 'n?vim' ~= nil
end

--- @param window _.wezterm.Window
--- @param pane _.wezterm.Pane
--- @param pane_direction 'Right' | 'Left' | 'Up' | 'Down'
--- @param vim_direction 'h' | 'j' | 'k' | 'l
local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
  if is_vi_process(pane) then
    window:perform_action(wezterm.action.SendKey { key = vim_direction, mods = 'CTRL' }, pane)
  else
    window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
  end
end

local M = {}

--- @type table<string, fun(window: _.wezterm.Window, pane: _.wezterm.Pane)>
local event_map = {
  ['ActivatePaneDirection-right'] = function(window, pane)
    conditional_activate_pane(window, pane, 'Right', 'l')
  end,
  ['ActivatePaneDirection-left'] = function(window, pane)
    conditional_activate_pane(window, pane, 'Left', 'h')
  end,
  ['ActivatePaneDirection-up'] = function(window, pane)
    conditional_activate_pane(window, pane, 'Up', 'k')
  end,
  ['ActivatePaneDirection-down'] = function(window, pane)
    conditional_activate_pane(window, pane, 'Down', 'j')
  end,
}

M.setup_navigation = function()
  -- for each event in event_map, register a callback
  for event_name, callback in pairs(event_map) do
    wezterm.on(event_name, callback)
  end
end

return M
