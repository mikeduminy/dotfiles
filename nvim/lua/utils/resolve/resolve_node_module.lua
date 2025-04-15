local fileUtils = require("utils.file")
local tableUtils = require("utils.table")

local function get_all_extensions()
  local known_suffixes = { "", ".native", ".ios", ".android", ".web", ".extension", ".xpay", ".merchant-integration" }
  local known_extensions = { ".ts", ".tsx", ".js", ".jsx" }

  local result = tableUtils.shallow_copy(known_extensions)

  for _, suffix in pairs(known_suffixes) do
    for _, ext in pairs(known_extensions) do
      result[suffix .. ext] = suffix .. ext
    end
  end
  return result
end

---@param file string
local function expand_extensions(file)
  local result = {}
  for _, ext in pairs(get_all_extensions()) do
    result[file .. ext] = file .. ext
  end
  return result
end

---@param path string
---@param mainFile string|nil
local function get_possible_paths(path, mainFile)
  if mainFile then
    local normalizedMain = string.gsub(mainFile, "^%p*", "")
    -- if there is a file extension we should trust it
    if fileUtils.get_file_extension(normalizedMain) then
      return { path .. normalizedMain }
    end

    return expand_extensions(path .. normalizedMain)
  end

  return expand_extensions(path .. "index")
end

---@param filename string
local function resolve_node_module(filename)
  local module_path = "./node_modules/" .. filename .. "/"
  local packageJsonPath = module_path .. "package.json"

  if fileUtils.readable(packageJsonPath) then
    ---@type string|nil
    local main = vim.fn.json_decode(vim.fn.readfile(packageJsonPath)).main
    local possiblePaths = get_possible_paths(module_path, main)
    for _, path in pairs(possiblePaths) do
      if fileUtils.readable(path) then
        return path
      end
    end
  end

  return module_path
end

return resolve_node_module
