local keymaps = require 'utils.keymaps'
local s = require 'utils.table'.to_string
local file_utils = require 'utils.file'
local cmd = vim.cmd
local strcmd = keymaps.strcmd
local allmap = keymaps.allmap
local nmap = keymaps.nmap
local map = keymaps.map

-- Leader set to <space>
vim.g.mapleader = ' '

local globalBuffer = '"+' -- global clipboard
local nullBuffer = '"_' -- like piping to /dev/null

-- Close tmp windows (Like GitFugitive) with <Leader>Q
local closeTmps = function()
  local path = file_utils.get_current_file()

  if string.find(path, '.tmp.') ~= nil then
    cmd 'q'
  end
end

local toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end

-- mappings that don't make sense in which-key
nmap('<esc>', ':nohlsearch<cr><esc>') -- close highlight search
map({ 't' }, '<esc>', '<c-\\><c-n>') -- exit terminal mode, back to normal mode

allmap('<c-h>', '<c-w>h') -- Focus window left
allmap('<c-j>', '<c-w>j') -- Focus window down
allmap('<c-k>', '<c-w>k') -- Focus window up
allmap('<c-l>', '<c-w>l') -- Focus window right

-- by default step through word-wrapped lines as if they were normal lines
map({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

map({ 'v' }, '<leader>y', s { globalBuffer, 'y' }) -- visual mode mapping for wk mapping

local wkMappings = {
  ['<leader>'] = {
    y = { s { globalBuffer, 'y' }, 'Copy to clipboard' },
    Y = { s { 'gg', globalBuffer, 'yG' }, 'Copy buffer to clipboard' },
    p = { s { nullBuffer, 'dP' }, 'Paste (no registers)', mode = "v" },
    qq = { strcmd 'qall', 'Quit' }, -- Try quit
    ww = { strcmd 'w', 'Write' }, -- Write current buffer
    wq = { strcmd 'wq', 'Write & Quit' },
    Q = { closeTmps, 'Close tmp buffer' },
    c = { toggle_qf, 'Toggle quickfix' },
  },
}

keymaps.register(wkMappings)
