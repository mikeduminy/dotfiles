-- File content largely adapted from Snacks.nvim, all rights reserved to the
-- original author.
-- https://github.com/folke/snacks.nvim/blob/b9900444d2ea494bba8857e5224059002ee8c465/lua/snacks/picker/util/kv.lua

local wezterm = require 'wezterm'
local file = require 'utils.file'

---@class utils.KeyValue
---@field data table<string, number>
---@field loaded_time number
---@field path string
---@field max_size number
---@field cmp fun(a:utils.KeyValue.entry, b:utils.KeyValue.entry): boolean
local M = {}
M.__index = M

local MAX_SIZE = 10000

---@alias utils.KeyValue.entry {key:string, value:number}

--- Creates a new KeyValue store at the specified path.
---@param path string
function M.new(path)
  local self = setmetatable({}, M)
  self.data = {}
  self.path = path
  ---@param a utils.KeyValue.entry
  ---@param b utils.KeyValue.entry
  self.cmp = function(a, b)
    return a.value > b.value
  end
  self.loaded_time = os.time()
  wezterm.log_info('Loading KeyValue store from ' .. path)
  local fd = io.open(path, 'rb')
  wezterm.log_info('KeyValue store loaded from ' .. path)
  if fd then
    wezterm.log_info('KeyValue store loaded from 2 ' .. path)
    ---@type string
    local data = fd:read '*a'
    fd:close()
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.data = require('string.buffer').decode(data) or {}
    wezterm.log_info('KeyValue store loaded' .. self.data)
  end
  return self
end

function M:set(key, value)
  self.data[key] = value
end

function M:get(key)
  return self.data[key]
end

function M:get_all()
  return self.data
end

--- Saves the current state of the KeyValue store to the file specified by `self.path`.
--- Ensures the directory exists, checks for file modifications, and writes the data in sorted order.
function M:close()
  -- Extract the directory path from the file path
  local path_dir = self.path:match '(.*/)'
  if path_dir then
    -- Create the directory if it doesn't exist
    os.execute('mkdir -p ' .. path_dir)
  end

  -- Get the file's current metadata
  local stat = file.fs_stat(self.path)
  -- If the file was modified after it was loaded, skip saving
  if self.loaded_time > 0 and stat > self.loaded_time then
    return
  end

  -- Convert the data table into a list of entries for sorting
  local entries = {} ---@type utils.KeyValue.entry[]
  for k, v in pairs(self.data) do
    table.insert(entries, { key = k, value = v })
  end

  -- Sort the entries using the comparison function
  table.sort(entries, self.cmp)

  -- Trim the data to respect the maximum size
  self.data = {}
  for i = 1, math.min(#entries, MAX_SIZE) do
    local entry = entries[i]
    self.data[entry.key] = entry.value
  end

  -- Encode the data into a string format
  local data = require('string.buffer').encode(self.data)

  -- Write the encoded data to the file
  local fd = io.open(self.path, 'w+b')
  if not fd then
    return
  end
  fd:write(data)
  fd:close()
end

return M
