local wezterm = require 'wezterm'

local module = {}

local debug = true

local plugins = {}

function module.getPlugins()
  -- if plugins has anything in it, return it
  if #plugins > 0 then
    return plugins
  end

  local pluginNames = {}
  for pluginName in io.popen([[ls -p $XDG_CONFIG_HOME/plugins | grep \/ | sed 's:/*$::']]):lines() do
    table.insert(pluginNames, { name = pluginName })
  end
  for _, pluginName in ipairs(pluginNames) do
    local status, result = pcall(require, pluginName.name .. '/wezterm')
    if status then
      table.insert(plugins, { name = pluginName.name, module = result })
      if debug then
        wezterm.log_info('loaded ' .. pluginName.name)
      end
    else
      wezterm.log_error('failed to load', pluginName.name)
    end
  end

  return plugins
end

return module
