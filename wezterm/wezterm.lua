local wezterm = require 'wezterm'
local colors = require 'colors'
local navigation = require 'navigation'
local multiplex = require 'multiplex'
local projects = require 'lib.projects'
local file = require 'utils.file'

-- setup zen mode
require 'lib.zenmode'

navigation.setup_navigation()
multiplex.setup_multiplexer()

local function get_process(tab)
  local process_icons = {
    ['nvim'] = {
      { Foreground = { Color = colors.green } },
      { Text = wezterm.nerdfonts.custom_vim },
    },
    ['vim'] = {
      { Foreground = { Color = colors.green } },
      { Text = wezterm.nerdfonts.dev_vim },
    },
    ['node'] = {
      { Foreground = { Color = colors.green } },
      { Text = wezterm.nerdfonts.mdi_hexagon },
    },
    ['zsh'] = {
      { Foreground = { Color = colors.peach } },
      { Text = wezterm.nerdfonts.dev_terminal },
    },
    ['git'] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ['lazygit'] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ['lua'] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.seti_lua },
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')

  return wezterm.format(
    process_icons[process_name]
      or { { Foreground = { Color = colors.sky } }, { Text = string.format('[%s]', process_name) } }
  )
end

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir
  local HOME_DIR = string.format('file://%s', os.getenv 'HOME')

  return current_dir == HOME_DIR and '  ~'
    or string.format('  %s', string.gsub(current_dir, '(.*[/\\])(.*)', '%2'))
end

wezterm.on('format-tab-title', function(tab)
  return wezterm.format {
    { Attribute = { Intensity = 'Half' } },
    { Text = string.format(' %s  ', tab.tab_index + 1) },
    'ResetAttributes',
    { Text = get_process(tab) },
    { Text = ' ' },
    { Text = get_current_working_dir(tab) },
    { Text = ' ' },
    { Attribute = { Intensity = 'Half' } },
    { Text = '|' },
  }
end)

wezterm.on('update-status', function(window)
  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = 'Half' } },
    { Attribute = { Italic = true } },
    { Text = wezterm.strftime ' %A, %d %B %Y %I:%M %p ' },
  })
end)

return {
  font = wezterm.font_with_fallback {
    'JetBrains Mono',
    'FiraCode Nerd Font',
  },
  font_size = 14.5,
  adjust_window_size_when_changing_font_size = false,
  line_height = 1.1,
  window_decorations = 'TITLE|RESIZE',
  color_scheme = 'tokyonight_moon',
  window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0cell',
    bottom = '0cell',
  },
  window_background_opacity = 0.95,
  use_resize_increments = true,
  use_fancy_tab_bar = true,
  initial_cols = 110,
  initial_rows = 25,
  inactive_pane_hsb = {
    hue = 1.0,
    saturation = 0.9,
    brightness = 0.8,
  },
  tab_bar_at_bottom = false,
  show_new_tab_button_in_tab_bar = false,
  tab_max_width = 50,
  keys = {
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
      action = wezterm.action.InputSelector {
        title = 'Open Workspace',
        choices = projects.getWorkspaceChoices(),
        action = wezterm.action_callback(function(window, pane, id, label)
          if not id and not label then
            wezterm.log_info 'cancelled'
          else
            window:perform_action(
              wezterm.action.SwitchToWorkspace {
                name = file.basename(label),
                spawn = {
                  cwd = id,
                },
              },
              pane
            )
          end
        end),
      },
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

    { key = 'z', mods = 'CMD', action = wezterm.action.TogglePaneZoomState },

    { key = 'h', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
    { key = 'j', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
    { key = 'k', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
    { key = 'l', mods = 'CMD|CTRL', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

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
  },
  scrollback_lines = 6000, -- default is 3500
  switch_to_last_active_tab_when_closing_tab = true, -- default is false
  front_end = 'WebGpu',
  audible_bell = 'Disabled',
  max_fps = 120,
  hide_tab_bar_if_only_one_tab = true,
}

-- Hot to upgrade wezterm
-- brew upgrade --cask wez/wezterm/wezterm
