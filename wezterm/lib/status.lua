local wezterm = require 'wezterm'
local colors = require 'colors'
local zoom = require 'lib.zoom'
local utils = require 'utils'

local module = {}

--- @param _ _.wezterm.Window
--- @param pane _.wezterm.Pane
local function buildLeftStatus(_, pane)
  local status = {}
  table.insert(status, { Text = ' ' })

  local cwdUrl = pane:get_current_working_dir()
  if not cwdUrl then
    return status
  end

  -- replace home dir with ~
  local escapedHomeDir = utils.escapePattern(wezterm.home_dir)
  local cwd = cwdUrl.file_path:gsub(escapedHomeDir, '~', 1)

  table.insert(status, { Attribute = { Intensity = 'Half' } })
  table.insert(status, { Foreground = { Color = colors.lavender } })
  table.insert(status, { Text = cwd })

  return status
end

--- @param window _.wezterm.Window
--- @param pane _.wezterm.Pane
local function buildRightStatus(window, pane)
  local status = {}

  if zoom.is_zoomed(pane) then
    table.insert(status, { Attribute = { Underline = 'Single' } })
    table.insert(status, { Foreground = { Color = colors.red } })
    table.insert(status, { Text = '[ focused ]' })
  end

  if #status > 0 then
    table.insert(status, 'ResetAttributes')
    table.insert(status, { Text = ' ' })
  end

  table.insert(status, { Attribute = { Intensity = 'Half' } })
  table.insert(status, { Text = 'Workspace is ' })
  table.insert(status, { Attribute = { Intensity = 'Bold' } })
  table.insert(status, { Foreground = { Color = colors.blue } })
  table.insert(status, { Text = window:active_workspace() })
  table.insert(status, { Text = ' ' })

  return status
end

--- @param window _.wezterm.Window
--- @param pane _.wezterm.Pane
function module.handle_status(window, pane)
  local new_left_status = buildLeftStatus(window, pane)
  window:set_left_status(wezterm.format(new_left_status))

  local new_right_status = buildRightStatus(window, pane)
  window:set_right_status(wezterm.format(new_right_status))
end

return module
