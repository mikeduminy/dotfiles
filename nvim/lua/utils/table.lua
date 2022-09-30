local function get_length(tbl)
  local getN = 0
  for _ in pairs(tbl) do
    getN = getN + 1
  end
  return getN
end

local merge = function(a, b)
  local c = {}

  for k, v in pairs(a) do
    c[k] = v
  end
  for k, v in pairs(b) do
    c[k] = v
  end

  return c
end

local to_string = function(tbl)
  return table.concat(tbl, '')
end

local shallow_copy = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

local M = {
  get_length = get_length,
  merge = merge,
  to_string = to_string,
  shallow_copy = shallow_copy,
}

return M
