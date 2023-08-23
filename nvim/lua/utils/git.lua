local M = {}

function M.get_file()
  -- get git root directory
  local handle = io.popen("git rev-parse --show-toplevel")
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
  -- get the remote url
  local handle = io.popen("git config --get remote.origin.url")
  if handle == nil then
    return ""
  end
  local result = handle:read("*a")

  if result == "" then
    print("No remote found")
    return ""
  end
  handle:close()
  local ssh, user, domain, port, group, repo = result:match("(ssh://)([^@]+)@([^:]+):(%d+)/([^/]+)/([^/]+).git")

  local git_remote_url = ("https://%s/projects/%s/repos/%s/browse/"):format(domain, group:upper(), repo)

  return git_remote_url
end

return M
