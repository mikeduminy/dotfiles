local M = {}

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

-- TODO: add support for http/https
-- TODO: add support for branch and commit
function M.get_line_on_remote()
  local remote = M.get_remote()
  if not remote then
    return ""
  end

  local file_path = M.get_file()
  local line_number = vim.api.nvim__buf_stats(0).current_lnum

  -- extract parts from
  -- ssh://git@stash.something:9999/~username/dashboard.git
  if string.find(remote, "stash") then
    local ssh, user, domain, port, group, repo = remote:match("(ssh://)([^@]+)@([^:]+):(%d+)/([^/]+)/([^/]+).git")

    local git_remote_url = ("https://%s/projects/%s/repos/%s/browse/"):format(domain, group:upper(), repo)
    return git_remote_url .. file_path .. "#" .. line_number
  end

  -- git@github.com:mikeduminy/dotfiles.git
  -- - https://github.com/mikeduminy/dotfiles/blob/main/install.sh#L7
  if string.find(remote, "github") then
    local user, repo = remote:match("github.com:(.+)/(.+).git")
    local github_url = "https://github.com/" .. user .. "/" .. repo
    local branch = "main" -- TODO: get the current branch
    if branch == nil then
      branch = "main"
    end
    local git_remote_url_with_line = github_url .. "/blob/" .. branch .. "/" .. file_path .. "#L" .. line_number
    return git_remote_url_with_line
  end
end

return M
