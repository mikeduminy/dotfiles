local mergeTables = require("utils.table").merge
local keymap = vim.keymap

local M = {}

function M.map(mode, shortcut, command, options)
  if options and options.executeCommand then
    command = "<cmd>" .. command .. "<cr>"
    options.executeCommand = nil
  end
  keymap.set(mode, shortcut, command, mergeTables({ noremap = true, silent = true }, options or {}))
end

-- Normal mode key mapping
function M.nmap(shortcut, command, options)
  M.map("n", shortcut, command, options)
end

-- Visual mode key mapping
function M.vmap(shortcut, command, options)
  M.map("v", shortcut, command, options)
end

function M.allmap(shortcut, command, options)
  local allModes = { "n", "v", "s", "t", "o", "i", "c" }
  M.map(allModes, shortcut, command, options)
end

-- Helper to generate command syntax
---@return string
function M.strcmd(command, options)
  if options and options.lua then
    return "<cmd>lua " .. command .. "<cr>"
  end
  return "<cmd>" .. command .. "<cr>"
end

---@return string
function M.luacmd(command)
  return M.strcmd(command, { lua = true })
end

local transform = false
function M.register(mappings)
  if transform then
    local transformedMappings = {}
    for key, value in pairs(mappings) do
      transformedMappings[key] = value
    end

    require("which-key").add(transformedMappings)
  else
    require("which-key").add(mappings)
  end
end

return M
