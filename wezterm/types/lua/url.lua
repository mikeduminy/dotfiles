---@meta

---@class _.wezterm.URL
---@field scheme string
---@field file_path string
---@field username string
---@field password? string
---@field host string
---@field path string
---@field fragment string
---@field query string

---@class _.wezterm.Url
local Url = {}

---@param url string
---@return _.wezterm.URL
function Url:parse(url) end

return Url
