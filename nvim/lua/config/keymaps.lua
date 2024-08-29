-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local file_utils = require("utils.file")
local git_utils = require("utils.git")

-- vendored from lazyvim https://github.com/LazyVim/LazyVim/blob/f9dadc11b39fb0b027473caaab2200b35c9f0c8b/lua/lazyvim/config/keymaps.lua
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-----------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------

map("n", "<Leader>n", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<Leader>N", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

map({ "i" }, "jk", "<esc>") -- quick 'jk' in insert mode fires escape

-- safe paste
map({ "n", "v" }, "<leader>p", '"_dP', { desc = "Paste over" })

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- modifier (CMD on mac, CTRL on other)
local withModifier = function(key)
  local mod = vim.fn.has("mac") == 1 and "D" or "C"
  return "<" .. mod .. "-" .. key .. ">"
end

-- hack for better saving using CMD+s
map("n", withModifier("s"), ":write", { desc = "Save buffer", remap = true })

map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save & Quit" })

-- splits
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w_", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>_", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- navigating between windows
map("n", withModifier("h"), "<C-w>h", { desc = "Go to left window", remap = true })
map("n", withModifier("j"), "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", withModifier("k"), "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", withModifier("l"), "<C-w>l", { desc = "Go to right window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>N", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- center screen
map("n", "<C-u>", "<C-u>zz", { desc = "Screen up (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Screen down (centered)" })
map("n", "gg", "ggzz", { desc = "Scroll to top (centered)" })
map("n", "G", "Gzz", { desc = "Scroll to bottom (centered)" })
map("n", "n", "nzzzv", { desc = "Search next (centered)" })
map("n", "N", "Nzzzv", { desc = "Search prev (centered)" })
map("n", "}", "}zz", { desc = "Move to next paragraph (centered)" })
map("n", "{", "{zz", { desc = "Move to prev paragraph (centered)" })

-- copy file path (relative)
map("n", "<leader>cp", function()
  local file_path = file_utils.get_current_file({ relative = true })
  vim.fn.setreg("+", file_path)

  vim.notify("Copied to clipboard\n" .. file_path, vim.log.levels.INFO, { title = "File Path" })
end, { desc = "Copy Relative File Path" })

-- copy file path (git)
map("n", "<leader>sp", function()
  local url = git_utils.get_line_on_remote()
  vim.fn.setreg("+", url)

  vim.notify("Copied to clipboard\n" .. url, vim.log.levels.INFO, { title = "Git URL" })
end, { desc = "Copy Git File Path URL" })

-- prompt to remove all open buffers
map("n", "<leader>bo", function()
  local choice = vim.fn.confirm("Delete all buffers?", "&Yes\n&No\n&Cancel")
  if choice == 1 then
    -- "%bd" = delete all buffers
    -- "e#" = open last buffer for editing
    -- "bd#" = delete created [No Name] buffer
    vim.cmd("%bd | e# | bd#")
  end
end, { desc = "Delete all buffers" })

-- navigate to next item in quickfix list
map("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next()
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next trouble/quickfix item" })

-- navigate to prev item in quickfix list
map("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev()
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next trouble/quickfix item" })

-- navigate to next FILE in quickfix list
map("n", "]Q", function()
  if require("trouble").is_open() then
    -- trouble doesn't have an API for this
  else
    local ok, err = pcall(vim.cmd.cnfile)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next quickfix file" })

-- navigate to prev FILE in quickfix list
map("n", "[Q", function()
  if require("trouble").is_open() then
    -- trouble doesn't have an API for this
  else
    local ok, err = pcall(vim.cmd.cpfile)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Previous quickfix file" })
