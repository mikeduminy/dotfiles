local file = require 'utils.file'
local wezterm = require 'wezterm'
local mux = wezterm.mux

local debug = false
local config_dir = os.getenv 'XDG_CONFIG_HOME'
package.path = package.path .. ';' .. config_dir .. '/plugins/?/init.lua'

local M = {}

local function spawnCodingDomain(name, project_dir, opts)
  local split, start_editor
  if opts then
    split = opts.split or false
    start_editor = opts.start_editor or false
  end

  local tab, editor_pane, window = mux.spawn_window {
    workspace = name,
    cwd = project_dir,
  }

  if split then
    local build_pane = editor_pane:split {
      direction = 'Right',
      size = 0.2,
      cwd = project_dir,
    }
  end

  if start_editor then
    editor_pane:send_text 'nvim .\n'
  end
end

local function getPlugins()
  local pluginNames = {}
  for pluginName in io.popen([[ls -p $XDG_CONFIG_HOME/plugins | grep \/ | sed 's:/*$::']]):lines() do
    table.insert(pluginNames, { name = pluginName })
  end

  debug = true

  local plugins = {}
  for _, pluginName in ipairs(pluginNames) do
    local status, result = pcall(require, pluginName.name .. '/wezterm')
    if status then
      table.insert(plugins, { name = pluginName.name, module = result })
      if debug then
        print('loaded ' .. pluginName.name)
      end
    else
      print('failed to load', pluginName.name)
    end
  end

  -- for _, plugin in ipairs(plugins) do
  --   print('loading coding domains for ' .. plugin.name)
  --   for _, domain in ipairs(plugin.module.get_coding_domains()) do
  --     print(domain.name .. ' ' .. domain.dir)
  --     -- spawnCodingDomain(domain.name, domain.dir, domain.opts or {})
  --   end
  -- end

  return plugins
end

M.setup_multiplexer = function()
  wezterm.on('gui-startup', function(_cmd)
    for _, plugin in ipairs(getPlugins()) do
      print('loading coding domains for ' .. plugin.name)
      for _, domain in ipairs(plugin.module.get_coding_domains()) do
        if file.is_dir(domain.dir) then
          spawnCodingDomain(domain.name, domain.dir, domain.opts or {})
        end
      end
    end

    -- We want to startup in the coding workspace
    -- mux.set_active_workspace 'config'
  end)
end

return M
