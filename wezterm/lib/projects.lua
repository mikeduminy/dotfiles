local wezterm = require 'wezterm'
local file = require 'utils.file'
local utils = require 'utils'

local module = {}

local function getBranchName(projectDir)
  local gitDir = projectDir .. '/.git'
  -- Check if the project is a git repository, we use file.exists instead of
  -- file.is_dir to handle the case where .git is a symlink
  if not (file.exists(gitDir)) then
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
    wezterm.log_error('failed to get branch name: ' .. stderr)
    return ''
  end

  return stdout
end

local function getProjects()
  return wezterm.GLOBAL.projects or {}
end

local function setProjects(projects)
  wezterm.GLOBAL.projects = projects
end

-- Returns a table of project names and their locations
local function buildProjects(project_dirs)
  local projects = {}

  for _, project_dir in ipairs(project_dirs) do
    local dirs = wezterm.read_dir(project_dir)
    for _, dir in ipairs(dirs) do
      if file.is_dir(dir) then
        local parent_dir = file.basename(file.dirname(dir))
        local child_dir = file.basename(dir)
        local branchName = getBranchName(dir)
        table.insert(projects, { name = parent_dir .. '/' .. child_dir, branch = branchName, location = dir })
      end
    end
  end

  return projects
end

--- @param input table
function module.setProjectRoots(input)
  local project_roots = wezterm.GLOBAL.project_roots or {}
  project_roots = utils.mergeValues(project_roots or {}, input)
  wezterm.GLOBAL.project_roots = project_roots

  local projects = buildProjects(project_roots)
  setProjects(projects)
end

-- Provides a table of choices for the workspace picker
function module.getWorkspaceChoices()
  local choices = {}

  table.insert(choices, { label = 'config', id = os.getenv 'XDG_CONFIG_HOME' })

  -- TODO: Add a frecency algorithm to sort the projects
  for _, project in ipairs(getProjects()) do
    local label = project.name
    if project.branch ~= '' then
      label = label .. ' | ' .. project.branch
    end
    table.insert(choices, { label = label, id = project.location })
  end

  return choices
end

return module
