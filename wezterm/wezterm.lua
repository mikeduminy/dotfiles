local wezterm = require 'wezterm'
local colors = require 'colors'
local navigation = require 'navigation'
local keys = require 'keys'
local status = require 'lib.status'
local events = require 'events'
local utils = require 'utils'

utils.log.enable_debug(false)

navigation.setup_navigation()

wezterm.on('user-var-changed', events.handle_user_var_changed)
wezterm.on('update-status', status.handle_status)

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

--- @param tab_info _.wezterm.TabInformation
local function get_current_working_dir(tab_info)
  local current_dir = tab_info.active_pane.current_working_dir.file_path
  local HOME_DIR = string.format('file://%s', os.getenv 'HOME')

  return current_dir == HOME_DIR and '  ~'
    or string.format('  %s', string.gsub(current_dir, '(.*[/\\])(.*)', '%2'))
end

--- @param tab_info _.wezterm.TabInformation
wezterm.on('format-tab-title', function(tab_info)
  local is_active = tab_info.is_active
  local intensity = is_active and 'Bold' or 'Half'

  return wezterm.format {
    { Text = ' ' },
    { Attribute = { Intensity = intensity } },
    { Foreground = { Color = is_active and colors.red or colors.blue } },
    { Text = is_active and '[' or ' ' },
    { Text = string.format(' %s ', tab_info.tab_index + 1) }, -- TODO: only show when more than 1 tab?
    { Text = is_active and ']' or ' ' },
    { Text = ' ' },
    { Text = get_process(tab_info) },
    { Text = (' '):rep(2) },
    -- { Text = get_current_working_dir(tab_info) },
  }
end)

local config = wezterm.config_builder()
config.default_cwd = wezterm.home_dir .. '/.xdg/config'
config.default_workspace = 'config'
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
}
config.font_size = 14.5
config.adjust_window_size_when_changing_font_size = false
config.line_height = 1.1
config.window_decorations = 'RESIZE'
config.color_scheme = 'tokyonight_moon'
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0cell',
  bottom = '0cell',
}
config.window_background_opacity = 0.88
config.macos_window_background_blur = 25
config.use_resize_increments = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_tabs_in_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.initial_cols = 110
config.initial_rows = 25
config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 0.9,
  brightness = 0.8,
}
config.keys = keys.key_table
config.scrollback_lines = 6000 -- default is 3500
config.switch_to_last_active_tab_when_closing_tab = true -- default is false
config.front_end = 'WebGpu'
config.audible_bell = 'Disabled'
config.max_fps = 120

return config

-- upgrade wezterm
-- brew upgrade --cask wez/wezterm/wezterm
-- upgrade wezterm@nightly
-- brew upgrade --cask wezterm@nightly --no-quarantine --greedy-latest
