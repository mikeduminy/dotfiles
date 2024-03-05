local module = {}

function module.readable(file_path)
  return vim.fn.filereadable(file_path) ~= 0
end

function module.is_directory(file_path)
  return vim.fn.isdirectory(file_path) ~= 0
end

function module.get_file_extension(url)
  return url:match("^.+(%..+)$")
end

function module.read(file_path)
  return vim.fn.readfile(file_path)
end

function module.get_current_file(opts)
  if opts and opts.relative then
    -- get current file relative to cwd
    return vim.fn.expand("%:~:.")
  end

  return vim.fn.expand("%")
end

function module.get_current_dir(opts)
  if opts and opts.absolute then
    -- get current dir relative to cwd
    return vim.fn.expand("%:~:.:h")
  end

  return vim.fn.expand("%:h")
end

--- Get the size of a buffer in KiB
---@param bufnr number
---@return integer|nil size in MiB if buffer is valid, nil otherwise
function module.get_buf_size(bufnr)
  local ok, stats = pcall(function()
    return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
  end)
  if not (ok and stats) then
    return nil
  end
  return stats.size
end

function module.get_root()
  return require("lazyvim.util").root.get()
end

-- Check if a file or directory exists in this path
--- @param file string
--- @return boolean, string?: true if it exists, false if not, and an optional error message
function module.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
--- @param path string
--- @return boolean, string?: true if it exists, false if not, and an optional error message
function module.is_dir(path)
  -- "/" works on both Unix and Windows
  return module.exists(path .. "/")
end

-- lua equivalents of POSIX functions

--- @param path string
--- @return string: filename path
module.basename = function(path)
  local _, filename = module._splitpath(path)
  return filename
end

--- @param path string
--- @return string: directory part
module.dirname = function(path)
  local dir, _ = module._splitpath(path)
  return dir
end

--- Split a path into directory and filename parts
--- @private
--- @param path string
--- @return string, string: directory part, filename part
function module._splitpath(path)
  return path:match("^(.-)[\\/]?([^\\/]*)$")
end

return module
