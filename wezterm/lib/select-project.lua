local wezterm = require 'wezterm'
local act = wezterm.action

local hacky_user_commands = {
  ['switch-workspace'] = function(window, pane, cmd_context)
    window:perform_action(
      act.SwitchToWorkspace {
        name = cmd_context.workspace,
        spawn = {
          cwd = cmd_context.cwd,
        },
      },
      pane
    )
  end,
}

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'custom-user-event' then
    print('custom-user-event', value)
    local cmd_context = wezterm.json_parse(value)
    hacky_user_commands[cmd_context.cmd](window, pane, cmd_context)
    return
  end
end)
