local string = require 'string'

local M = {}

--- Check if a file or directory exists in this path
M.exists = function(file)
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
M.is_dir = function(path)
  -- "/" works on both Unix and Windows
  return M.exists(path .. '/')
end

-- lua equivalents of POSIX functions
M.basename = function(P)
  local s1, s2 = M._splitpath(P)
  return s2
end

M.dirname = function(P)
  return (M._splitpath(P))
end

M._splitpath = function(P)
  return string.match(P, '^(.-)[\\/]?([^\\/]*)$')
end

return M
