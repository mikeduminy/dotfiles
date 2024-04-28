local wezterm = require 'wezterm'
local zenmode = require 'lib.zenmode'
local projects = require 'lib.projects'
local string = require 'utils.string'

local module = {}

--- @alias CustomCommandContext table<string, string>
--- @type table<string, fun(window: _.wezterm.Window, pane: _.wezterm.Pane, cmd_context: CustomCommandContext)>
local hacky_user_commands = {
  ['switch-workspace'] = function(window, pane, cmd_context)
    window:perform_action(
      wezterm.action.SwitchToWorkspace {
        name = cmd_context.workspace,
        spawn = {
          cwd = cmd_context.cwd,
        },
      },
      pane
    )
  end,
}

--- @type table<string, WeztermEventCallback>
local event_map = {
  ['custom-user-event'] = function(window, pane, name, value)
    if name ~= 'custom-user-event' then
      return
    end

    local cmd_context = wezterm.json_parse(value)
    hacky_user_commands[cmd_context.cmd](window, pane, cmd_context)
  end,
  ['PROJECT_ROOTS'] = function(_, _, _, value)
    local roots = string.split(value, ':')
    projects.setProjectRoots(roots)
  end,
  ['ZEN_MODE'] = zenmode.handle_event,
}

--- @type WeztermEventCallback
function module.handle_user_var_changed(window, pane, name, value)
  local handler = event_map[name]
  if handler then
    handler(window, pane, name, value)
  end
end

return module
