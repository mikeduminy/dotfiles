-- initial setup
require 'plugins.packer'

local register = require 'utils.keymaps'.register
local debug = require 'utils.env'.debug

local split = vim.fn.split
local glob = vim.fn.glob


local pluginPath = string.format("%s/lua/plugins", vim.fn.stdpath('config'))

-- get a list of plugin init files
local plugins = glob(pluginPath .. '/*/init.lua', false, true)

for _, pluginInitPath in ipairs(plugins) do
  local requirePath = split('plugins' .. split(pluginInitPath, pluginPath)[1], [[\.lua]])[1]
  local status, result = pcall(require, requirePath)
  if status then
    if debug then
      print('loaded ' .. requirePath)
    end
  else
    print('failed to load', requirePath, result)
  end
end

-- get a list of mappings files
local mappingsFiles = glob(pluginPath .. '/**/mappings.lua', false, true)

-- register all keymaps
for _, mappingsFilePath in ipairs(mappingsFiles) do
  local requirePath = split('plugins' .. split(mappingsFilePath, pluginPath)[1], '.lua')[1]
  local status, result = pcall(require, requirePath)
  if status and type(result) == "table" then
    register(result)
  end
end
