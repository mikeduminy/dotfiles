local wezterm = require 'wezterm'
local file = require 'utils.file'
local plugins = require 'lib.plugins'

local M = {}

-- Returns a table of workspace names
local function getWorkspaces()
  local workspaces = {}

  for workspace_name in wezterm.mux.get_workspace_names() do
    table.insert(workspaces, { name = workspace_name })
  end

  return workspaces
end

-- Returns a table of project names and their locations
local function getProjects()
  local projects = {}
  local _plugins = plugins.getPlugins()

  for _, plugin in ipairs(_plugins) do
    wezterm.log_info(plugin.module.get_project_dir())
  end

  local base_search_command = 'fd --type=d --max-depth=1 .'

  local project_dirs = {}
  for _, plugin in ipairs(plugins.getPlugins()) do
    table.insert(project_dirs, plugin.module.get_project_dir())
  end

  -- local search_command = base_search_command .. ' ' .. table.concat(project_folders, ' ')
  -- wezterm.log_info('search_command ' .. search_command)

  for _, project_dir in ipairs(project_dirs) do
    local dirs = wezterm.read_dir(project_dir)
    for _, dir in ipairs(dirs) do
      if file.is_dir(dir) then
        wezterm.log_info(dir)
        local parent_dir = file.basename(file.dirname(dir))
        local child_dir = file.basename(dir)
        table.insert(projects, { name = parent_dir .. '/' .. child_dir, location = dir })
      end
    end
  end

  return projects
end

-- Stringify a table
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- Provides a table of choices for the workspace picker
M.getWorkspaceChoices = function()
  local choices = {}

  -- wezterm.log_info(table.concat(getWorkspaces(), ''))

  -- for _, workspace in ipairs(getWorkspaces()) do
  --   table.insert(choices, { label = workspace, id = 'Switch to ' .. workspace })
  -- end

  for _, project in ipairs(getProjects()) do
    table.insert(choices, { label = project.name, id = project.location })
  end

  wezterm.log_info('final choices: ' .. dump(choices))

  return choices
end

return M
