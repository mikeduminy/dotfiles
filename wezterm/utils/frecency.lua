local file = require 'utils.file'

-- Frecency based on exponential decay. Roughly based on:
-- https://wiki.mozilla.org/User:Jesse/NewFrecency?title=User:Jesse/NewFrecency
---@class utils.Frecency
---@field now number
---@field cache table<string, number>
local M = {}
M.__index = M

local data_dir = os.getenv 'XDG_DATA_DIR' or os.getenv 'HOME' .. '/.local/share'
local store_file = data_dir .. '/wezterm/frecency.dat'

local HALF_LIFE = 30 * 24 * 3600 -- Half-life = 30 days (in seconds)
local LAMBDA = math.log(2) / HALF_LIFE -- λ = ln(2) / half_life
local SEED_VALUE = 1
local DEFAULT_VALUE = 1

---@class utils.frecency.Store
---@field set fun(self:utils.frecency.Store, key:string, value:number)
---@field get fun(self:utils.frecency.Store, key:string):number
---@field close fun(self:utils.frecency.Store)
---@field get_all fun(self:utils.frecency.Store):table<string, number>

-- Global store of frecency deadlinesl
---@type utils.frecency.Store?
M.store = nil

function M.setup()
  -- if
  --   not pcall(function()
  --     local db = require('utils.sql').new(store_file .. '.sqlite3', 'number')
  --     M.store = db --[[@as utils.frecency.Store]]
  --     -- Cleanup old entries
  --     local cutoff = db:prepare 'SELECT value FROM data ORDER BY value DESC LIMIT 1 OFFSET ?;'
  --     if cutoff:exec { MAX_STORE_SIZE - 1 } == 100 then -- 100 == SQLITE_ROW
  --       db:prepare('DELETE FROM data WHERE value < ?;'):exec { cutoff:col 'number' }
  --     end
  --   end)
  -- then
  M.store = require('utils.kv').new(store_file) --[[@as utils.frecency.Store]]
  -- end

  -- local group = vim.api.nvim_create_augroup('snacks_picker_frecency', {})
  -- vim.api.nvim_create_autocmd('ExitPre', {
  --   group = group,
  --   callback = function()
  --     if M.store then
  --       M.store:close()
  --       M.store = nil
  --     end
  --   end,
  -- })
  -- vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  --   group = group,
  --   callback = function(ev)
  --     local current_win = vim.api.nvim_get_current_win()
  --     if vim.api.nvim_win_get_config(current_win).relative ~= '' then
  --       return
  --     end
  --     M.visit_buf(ev.buf)
  --   end,
  -- })
  -- -- Visit existing buffers
  -- for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  --   M.visit_buf(buf)
  -- end
end

function M.new()
  local self = setmetatable({}, M)
  self.now = os.time()
  if not M.store then
    M.setup()
  end
  self.cache = M.store:get_all()
  return self
end

--- Convert from a current score s into a "deadline date"
--- t = now() + (ln(s) / λ)
---@param score number
function M:to_deadline(score)
  return self.now + (math.log(score) / LAMBDA)
end

--- Convert from a "deadline date" back into a current score
--- s = e^(λ * (deadline - now))
function M:to_score(deadline)
  return math.exp(LAMBDA * (deadline - self.now))
end

--- Get the current frecency score for an item.
--- If the item is not tracked yet, it will seed it
--- based on the last used time or last modified time.
---@param item string
---@param opts? {seed?: boolean}
function M:get(item, opts)
  opts = opts or {}
  -- if item.dir then
  --   -- frecency of a directory is the sum of frecencies of all files in it
  --   local score = 0
  --   local prefix = path .. '/'
  --   for k, v in pairs(self.cache) do
  --     if k:find(prefix, 1, true) == 1 then
  --       score = score + self:to_score(v)
  --     end
  --   end
  --   return score
  -- end
  local deadline = self.cache[item]
  if not deadline then
    return opts.seed ~= false and self:seed(item) or 0
  end
  return self:to_score(deadline)
end

---@param item string
---@param value? number
function M:seed(item, value)
  -- only seed recent files or items with buffer info
  -- if not (item.info or item.recent) then
  --   return 0
  -- end
  local last_used = nil -- type(item.info) == 'table' and item.info.lastused or nil
  local path = item
  if not path then
    return 0
  end
  if not last_used then
    local stat = file.fs_stat(path)
    last_used = stat
  end
  if not last_used then
    return 0
  end
  -- Calculate decayed single-visit score
  local dt = self.now - last_used -- in seconds
  return (value or SEED_VALUE) * math.exp(-LAMBDA * dt)
end

--- Add a "visit" to the item.
--- If the item doesn't exist, it is created with initial score = `visit_value`.
--- Otherwise, the new score is old_score + visit_value.
---@param item string
---@param value? number @the "points" to add (e.g. typed=2, clicked=1, etc.)
function M:visit(item, value)
  local path = item
  if not path then
    return
  end
  local score = self:get(item, { seed = false }) + (value or DEFAULT_VALUE)
  self.store:set(path, self:to_deadline(score))
end

---@param item string
function M.increment(item)
  local frecency = M.new()
  frecency:visit(item, 1)
end

-- ---@param buf number
-- ---@param value? number
-- function M.visit_buf(buf, value)
--   if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= '' or not vim.bo[buf].buflisted then
--     return
--   end
--   local file = vim.api.nvim_buf_get_name(buf)
--   if file == '' or not vim.uv.fs_stat(file) then
--     return
--   end
--   local frecency = M.new()
--   frecency:visit({
--     text = '',
--     idx = 1,
--     score = 0,
--     file = file,
--     buf = buf,
--     info = vim.fn.getbufinfo(buf)[1],
--   }, value)
--   return true
-- end

return M
