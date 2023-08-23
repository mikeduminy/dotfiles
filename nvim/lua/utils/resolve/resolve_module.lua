local fileUtils = require("utils.file")
local resolve_lua_module = require("utils.resolve.resolve_lua_module")
local resolve_node_module = require("utils.resolve.resolve_node_module")

local supported_file_resolutions = {
  [".lua"] = resolve_lua_module,
  [".js"] = resolve_node_module,
  [".ts"] = resolve_node_module,
  [".jsx"] = resolve_node_module,
  [".tsx"] = resolve_node_module,
}

return function(file_name)
  local current_file = fileUtils.get_current_file({ relative = true })
  local file_ext = fileUtils.get_file_extension(current_file)

  if supported_file_resolutions[file_ext] then
    local result = supported_file_resolutions[file_ext](file_name)
    return result
  end
end
