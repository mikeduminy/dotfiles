local debug = false

-- initial setup
require 'plugins.setup'

local register = require 'utils.keymaps'.register

local stdpath = vim.fn.stdpath
local split = vim.fn.split
local glob = vim.fn.glob

local pluginPath = string.format("%s/lua/plugins", stdpath('config'))

-- get a list of plugin init files
local plugins = glob(pluginPath .. '/*/init.lua', false, true)

for _, pluginInitPath in ipairs(plugins) do
  local requirePath = split('plugins' .. split(pluginInitPath, pluginPath)[1], [[\.lua]])[1]
  local status, _ = pcall(require, requirePath)
  if status then
    if debug then
      print('loaded ' .. requirePath)
    end
  else
    print('failed to load', requirePath)
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

-- "/Users/michael-james.duminy/.xdg/config/nvim/lua/plugins"


-- -- setup theming first
-- require 'plugins.base16'

-- -- base gui plugins
-- require 'plugins.neo-tree'
-- require 'plugins.alpha-nvim'
-- require 'plugins.bufferline-nvim'
-- require 'plugins.nvim-scrollbar'
-- require 'plugins.lualine'

-- -- other plugins
-- require 'plugins.editorconfig'
-- require 'plugins.gitsigns'
-- require 'plugins.harpoon'
-- require 'plugins.indentline'
-- require 'plugins.nvim-cmp'
-- require 'plugins.nvim-lsp'
-- require 'plugins.nvim-web-devicons'
-- require 'plugins.telescope'
-- require 'plugins.treesitter'
-- require 'plugins.trouble'
-- require 'plugins.nvim-autopairs'
-- require 'plugins.which-key'
