local module = {}

--- @param a string
--- @param b string
local function sort_alphabetical(a, b)
  return a:lower() < b:lower()
end

--- @param tblA table
--- @param tblB table
function module.mergeValues(tblA, tblB)
  if not next(tblA) then
    -- if a is empty, sort b and return it
    table.sort(tblB, sort_alphabetical)
    return tblB
  end

  -- otherwise, merge the tables into a single dictionary
  local mergeDict = {}
  for _, v in pairs(tblA) do
    mergeDict[v] = v
  end
  for _, v in pairs(tblB) do
    mergeDict[v] = v
  end

  -- convert to array and sort it alphabetically
  local mergeArr = {}
  for _, v in pairs(mergeDict) do
    table.insert(mergeArr, v)
  end

  table.sort(mergeArr, sort_alphabetical)
  return mergeArr
end

return module
