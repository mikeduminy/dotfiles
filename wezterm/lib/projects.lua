local wezterm = require 'wezterm'
local file = require 'utils.file'
local utils = require 'utils'
local string = require 'utils.string'

local module = {}

--- @return table<string>
local function _getProjects()
  return wezterm.GLOBAL.projects or {}
end

--- @param projects table<string>
local function _setProjects(projects)
  wezterm.GLOBAL.projects = projects
end

--- @return table<string>
local function _getProjectRoots()
  return string.split(wezterm.GLOBAL.project_roots or '', ':')
end

--- @param roots table<string>
local function _setProjectRoots(roots)
  wezterm.GLOBAL.project_roots = table.concat(roots, ':')
end

--- @param projectDir string The directory of the project
local function getBranchName(projectDir)
  local gitDir = projectDir .. '/.git'
  -- Check if the project is a git repository, we use file.exists instead of
  -- file.is_dir to handle the case where .git is a symlink
  if not (file.exists(gitDir)) then
    utils.log.debug('not a git repository: ' .. projectDir)
    return ''
  end

  local success, stdout, stderr = wezterm.run_child_process {
    'git',
    '--git-dir',
    gitDir,
    '--work-tree',
    projectDir,
    '--no-pager',
    'rev-parse',
    '--abbrev-ref',
    'HEAD',
  }
  if not success then
    utils.log.debug('failed to get branch name: ' .. stderr)
    return ''
  end

  return string.split(stdout, '\n')[1]
end

--- Returns a table of project names and their locations
--- @param project_dirs table<string>
local function buildProjects(project_dirs)
  --- @type table<string, table>
  local projects = {}

  for _, project_dir in ipairs(project_dirs) do
    local dirs = wezterm.read_dir(project_dir)
    for _, dir in ipairs(dirs) do
      if file.is_dir(dir) then
        local parent_dir = file.basename(file.dirname(dir))
        local child_dir = file.basename(dir)
        local branchName = getBranchName(dir)
        local project = { name = parent_dir .. '/' .. child_dir, branch = branchName, location = dir }
        table.insert(projects, project)
      end
    end
  end

  return projects
end

--- @param input table
function module.setProjectRoots(input)
  local roots = _getProjectRoots()
  local newRoots = utils.mergeValues(roots, input)
  _setProjectRoots(newRoots)

  local project_roots = _getProjectRoots()
  local projects = buildProjects(project_roots)
  _setProjects(projects)
end

-- Provides a table of choices for the workspace picker
function module.getWorkspaceChoices()
  local choices = {}

  table.insert(choices, { label = 'config', id = os.getenv 'XDG_CONFIG_HOME' })

  -- TODO: Add a frecency algorithm to sort the projects
  for _, project in ipairs(_getProjects()) do
    local label = project.name
    if project.branch ~= '' then
      label = label .. ' | ' .. project.branch
    end
    table.insert(choices, { label = label, id = project.location })
  end

  return choices
end

return module
