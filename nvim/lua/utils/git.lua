local M = {}

--- @alias RemoteUrlPattern string

--- Patterns for different git remotes
--- @type table<RemoteUrlPattern, fun(remote: string, file_path: string, line_number: integer, use_current_branch: boolean ): string>
local remotes_patterns = {
  --- Bitbucket server (stash)
  ["stash"] = function(remote, file_path, line_number, use_current_branch)
    -- extract parts from ssh://git@stash.something:9999/~username/dashboard.git
    -- output url: https://stash.something/projects/USERNAME/repos/DASHBOARD/browse/path/to/file#L10
    local ssh, user, domain, port, group, repo = remote:match("(ssh://)([^@]+)@([^:]+):(%d+)/([^/]+)/([^/]+).git")

    local branch = use_current_branch and M.get_branch() or M.get_main_branch_name()

    local git_remote_url = ("https://%s/projects/%s/repos/%s/browse/"):format(domain, group:upper(), repo)
    local remote_url_with_branch = git_remote_url .. "?at=" .. branch
    local remote_url_with_file = remote_url_with_branch .. file_path .. "#" .. line_number
    return remote_url_with_file
  end,

  --- GitHub
  ["github.com"] = function(remote, file_path, line_number, use_current_branch)
    -- extract parts from git@github.com:mikeduminy/dotfiles.git
    -- output url: https://github.com/mikeduminy/dotfiles/blob/main/install.sh#L7
    local user, repo = remote:match("github.com:(.+)/(.+).git")
    local github_url = "https://github.com/" .. user .. "/" .. repo
    local branch = use_current_branch and M.get_branch() or "main"
    local git_remote_url = github_url .. "/blob/" .. branch .. "/"
    return git_remote_url .. file_path .. "#L" .. line_number
  end,

  --- GitHub Enterprise
  ["ghe.com"] = function(remote, file_path, line_number, use_current_branch)
    -- extract parts from user@company.ghe.com:company/repo.git
    -- output url https://company.ghe.com/username/repo/blob/main/file/path#L10
    local user, domain, repo = remote:match("([^@]+)@([^:]+):(.+).git")
    local ghe_url = "https://" .. domain .. "/" .. repo
    local branch = use_current_branch and M.get_branch() or "main"
    local git_remote_url = ghe_url .. "/blob/" .. branch .. "/"
    return git_remote_url .. file_path .. "#L" .. line_number
  end,
}

---@return string|nil
function M.get_branch()
  -- get the current branch
  local handle = io.popen("git branch --show-current")
  if handle == nil then
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  return result
end

function M.get_main_branch_name()
  -- get the main branch name
  local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'")
  if handle == nil then
    return nil
  end
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    result = "main"
  end
  return result
end

---@return string|nil
function M.get_file()
  -- get git root directory
  local handle = io.popen("git rev-parse --show-toplevel")
  if handle == nil then
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  -- get the relative file path
  local git_root_dir = result:match("^.*/")
  local file_path = vim.fn.expand("%:p")
  local relative_file_path = file_path:sub(#git_root_dir + 1)

  -- Remove the first folder from the relative file path
  local pos = relative_file_path:find("/")

  if pos then
    relative_file_path = relative_file_path:sub(pos + 1)
  end

  return relative_file_path
end

---@return string|nil
function M.get_remote()
  local handle = io.popen("git config --get remote.origin.url")
  if handle == nil then
    return nil
  end

  local result = handle:read("*a")

  if result == "" then
    print("No remote found")
    return ""
  end
  handle:close()

  return result
end

-- Get url to current line and path on remote repository
---@param for_current_branch boolean whether to use the current branch or main branch
---@return string|nil
function M.get_line_on_remote(for_current_branch)
  -- TODO: add support for http/https
  -- IDEA: add support for specific commit

  local remote = M.get_remote()
  if not remote then
    return ""
  end

  local file_path = M.get_file()
  if not file_path then
    return ""
  end

  local line_number = vim.api.nvim__buf_stats(0).current_lnum

  -- loop through remote names and match patterns if possible
  for name, value in pairs(remotes_patterns) do
    if string.find(remote, name) then
      return value(remote, file_path, line_number, for_current_branch)
    end
  end
end

return M
