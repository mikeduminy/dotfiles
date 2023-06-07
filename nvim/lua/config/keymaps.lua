-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

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

-- copy file path (relative)
map("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%:~:."))
end, { desc = "Copy Relative File Path" })

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
