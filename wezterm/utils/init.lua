local tableUtils = require 'utils.table'

local module = {}

-- Escapes special regex patterns in a string
--- @param pattern string: pattern to escape
--- @return string: escaped pattern
function module.escapePattern(pattern)
  -- List of special characters in Lua patterns
  local specialChars = { '^', '$', '(', ')', '%', '.', '[', ']', '*', '+', '-', '?' }

  -- Escape each special character in the pattern
  for _, char in ipairs(specialChars) do
    pattern = pattern:gsub('%' .. char, '%%' .. char)
  end

  return pattern
end

-- Concatenates two tables into one
--- @param t1 table
--- @param t2 table
function module.tconcat(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

module.mergeValues = tableUtils.mergeValues

return module
