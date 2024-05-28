local wezterm = require 'wezterm'
local zoom = require 'lib.zoom'
local projects = require 'lib.projects'

local module = {}

module.key_table = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'n',
    mods = 'CMD',
    action = wezterm.action { SpawnTab = 'CurrentPaneDomain' },
  },

  -- CMD+S -> CTRL+S
  {
    key = 's',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 's', mods = 'CTRL' },
  },

  {
    mods = 'CMD',
    key = [[\]],
    action = wezterm.action {
      SplitHorizontal = { domain = 'CurrentPaneDomain' },
    },
  },
  {
    mods = 'CMD|SHIFT',
    key = [[-]],
    action = wezterm.action {
      SplitVertical = { domain = 'CurrentPaneDomain' },
    },
  },

  -- CMD+SHIFT+O to switch workspaces
  {
    key = 'o',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- dynamically get list of projects
      local choices = projects.getWorkspaceChoices()

      window:perform_action(
        wezterm.action.InputSelector {
          title = 'Open Workspace',
          choices = choices,
          fuzzy = true,
          action = wezterm.action_callback(function(w, p, id, label)
            if not id and not label then
              wezterm.log_info 'cancelled'
            else
              local workspaceLabel = label
              -- get the first section of the label
              -- eg. "project-root/project-folder - branch-name" -> "project-root/project-folder"
              for i in string.gmatch(workspaceLabel, '[^%-]+') do
                workspaceLabel = i
                break
              end

              w:perform_action(
                wezterm.action.SwitchToWorkspace {
                  name = workspaceLabel,
                  spawn = {
                    cwd = id,
                  },
                },
                p
              )
            end
          end),
        },
        pane
      )
    end),
  },

  -- CMD+P to search open workspaces
  {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  -- CMD+SHIFT+P to search commands/actions
  {
    key = 'p',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|COMMANDS',
    },
  },

  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local title = window:mux_window():get_workspace()
      window:perform_action(
        wezterm.action.PromptInputLine {
          description = 'Enter new name for workspace "' .. title .. '"',
          action = wezterm.action_callback(function(_, _, line)
            if line then
              wezterm.log_info('Renaming from "' .. title .. '" to "' .. line .. '"')
              wezterm.mux.rename_workspace(title, line)
            end
          end),
        },
        pane
      )
    end),
  },

  { key = 'z', mods = 'CMD', action = zoom.toggle_pane_zoom },

  { key = 'h', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Left', 8 } },
  { key = 'j', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Down', 8 } },
  { key = 'k', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Up', 8 } },
  { key = 'l', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Right', 8 } },

  { key = 'h', mods = 'CMD', action = wezterm.action.EmitEvent 'ActivatePaneDirection-left' },
  { key = 'j', mods = 'CMD', action = wezterm.action.EmitEvent 'ActivatePaneDirection-down' },
  { key = 'k', mods = 'CMD', action = wezterm.action.EmitEvent 'ActivatePaneDirection-up' },
  { key = 'l', mods = 'CMD', action = wezterm.action.EmitEvent 'ActivatePaneDirection-right' },

  -- { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
  -- { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  -- { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  -- { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },

  { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.SwitchWorkspaceRelative(-1) },
  { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.SwitchWorkspaceRelative(1) },

  { key = '[', mods = 'ALT', action = wezterm.action { ActivateTabRelative = -1 } },
  { key = ']', mods = 'ALT', action = wezterm.action { ActivateTabRelative = 1 } },
  { key = 'v', mods = 'ALT', action = wezterm.action.ActivateCopyMode },
}

return module
