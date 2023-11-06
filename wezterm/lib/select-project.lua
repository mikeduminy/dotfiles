local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'switch-workspace' then
    local cmd_context = wezterm.json_parse(value)
    window:perform_action(
      act.SwitchToWorkspace {
        name = cmd_context.workspace,
        spawn = {
          cwd = cmd_context.cwd,
        },
      },
      pane
    )
  end
end)
