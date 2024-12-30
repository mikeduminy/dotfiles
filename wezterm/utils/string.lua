local module = {}

-- Split a string into a table by a delimiter
--- @param s string The string to split
--- @param delimiter string The delimiter to split by
function module.split(s, delimiter)
  delimiter = delimiter or '%s'
  local t = {}
  local i = 1
  for str in string.gmatch(s, '([^' .. delimiter .. ']+)') do
    t[i] = str
    i = i + 1
  end
  return t
end

return module
