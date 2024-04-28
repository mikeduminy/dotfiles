local module = {}

--- @param a table
--- @param b table
function module.mergeValues(a, b)
  local mergedTable = {}

  for _, v in pairs(a) do
    table.insert(mergedTable, v)
  end

  for _, v in pairs(b) do
    table.insert(mergedTable, v)
  end

  return mergedTable
end

return module
