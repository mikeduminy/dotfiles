local M = {}

M.get_project_dir = function()
  return os.getenv 'HOME' .. '/Source'
end

M.get_coding_domains = function()
  return {
    { name = 'config', dir = os.getenv 'XDG_CONFIG_HOME', opts = { start_editor = true } },
  }
end

return M
