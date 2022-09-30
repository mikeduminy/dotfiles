local mergeTables = require 'utils.table'.merge
local keymap = vim.keymap

local M = {}

function M.map(mode, shortcut, command, options)
  if options and options.executeCommand then
    command = '<cmd>' .. command .. '<cr>'
    options.executeCommand = nil
  end
  keymap.set(mode, shortcut, command, mergeTables({ noremap = true, silent = true }, options or {}))
end

-- Normal mode key mapping
function M.nmap(shortcut, command, options)
  M.map('n', shortcut, command, options)
end

-- Visual mode key mapping
function M.vmap(shortcut, command, options)
  M.map('v', shortcut, command, options)
end

-- Helper to generate command syntax
function M.strcmd(command, options)
  if options and options.lua then
    return '<cmd>lua ' .. command .. '<cr>'
  end
  return '<cmd>' .. command .. '<cr>'
end

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

    require 'which-key'.register(transformedMappings)
  else
    require 'which-key'.register(mappings)
  end
end

return M
