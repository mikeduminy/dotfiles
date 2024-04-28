local wezterm = require 'wezterm'
local file = require 'utils.file'
local utils = require 'utils'

local module = {}

local project_roots = nil

-- Returns a table of project names and their locations
local function getProjects()
  local projects = {}

  local project_dirs = project_roots or {}

  for _, project_dir in ipairs(project_dirs) do
    local dirs = wezterm.read_dir(project_dir)
    for _, dir in ipairs(dirs) do
      if file.is_dir(dir) then
        local parent_dir = file.basename(file.dirname(dir))
        local child_dir = file.basename(dir)
        table.insert(projects, { name = parent_dir .. '/' .. child_dir, location = dir })
      end
    end
  end

  return projects
end

--- @param input table
function module.setProjectRoots(input)
  project_roots = utils.mergeValues(project_roots or {}, input)
end

-- Provides a table of choices for the workspace picker
function module.getWorkspaceChoices()
  local choices = {}

  -- TODO: Add a frecency algorithm to sort the projects

  for _, project in ipairs(getProjects()) do
    table.insert(choices, { label = project.name, id = project.location })
  end

  table.insert(choices, { label = 'config', id = os.getenv 'XDG_CONFIG_HOME' })

  return choices
end

return module
