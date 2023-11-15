local module = {}

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
  return module.exists(path .. '/')
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
  return path:match '^(.-)[\\/]?([^\\/]*)$'
end

return module
