local cache_dir = os.getenv 'XDG_CACHE_HOME'
local config_dir = os.getenv 'XDG_CONFIG_HOME'

local vim_cache_dir = cache_dir .. '/nvim'
local backup_dir = vim_cache_dir .. '/backup'
local swp_dir = vim_cache_dir .. '/swp'
local undo_dir = vim_cache_dir .. '/undo'
local nvim_config_dir = config_dir .. '/nvim'
local fonts_dir = cache_dir .. '/.local/share/fonts'

local M = {
  backup_dir = backup_dir,
  home_dir = cache_dir,
  fonts_dir = fonts_dir,
  nvim_config_dir = nvim_config_dir,
  swp_dir = swp_dir,
  undo_dir = undo_dir,
  vim_cache_dir = vim_cache_dir,
}

return M
