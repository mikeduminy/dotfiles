local wezterm = require 'wezterm'

local M = {}

local debug_enabled = false

function M.enable_debug(enabled)
  debug_enabled = enabled
end

--- @param msg string
function M.debug(msg)
  if debug_enabled then
    wezterm.log_info(msg)
  end
end

--- @param msg string
function M.info(msg)
  wezterm.log_info(msg)
end

--- @param msg string
function M.error(msg)
  wezterm.log_error(msg)
end

--- @param msg string
function M.warn(msg)
  wezterm.log_warn(msg)
end

return M
