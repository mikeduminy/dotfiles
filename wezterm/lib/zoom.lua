local wezterm = require 'wezterm'
local paneUtils = require 'utils.pane'

local module = {}

--- A dictionary of pane_id -> boolean
--- true means that the pane is zoomed
--- @type table<number, boolean>
local pane_zoom = {}

--- Set the zoom state for a pane
--- @param is_zoomed boolean
--- @return nil
local function set_pane_zoom(pane, is_zoomed)
  pane_zoom[pane:pane_id()] = is_zoomed
end

module.toggle_pane_zoom = wezterm.action_callback(function(window, pane)
  local should_zoom = not paneUtils.get_pane_with_info(pane).is_zoomed
  set_pane_zoom(pane, should_zoom)
  return window:perform_action({ SetPaneZoomState = should_zoom }, pane)
end)

function module.is_zoomed(pane)
  local pane_info = paneUtils.get_pane_with_info(pane)
  if pane_info then
    set_pane_zoom(pane, pane_info.is_zoomed)
  end
  return pane_zoom[pane:pane_id()]
end

return module
