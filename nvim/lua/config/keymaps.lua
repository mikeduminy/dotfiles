-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-----------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------
vim.keymap.set("n", "<Leader>n", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<Leader>N", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

vim.keymap.set({ "i" }, "jk", "<esc>") -- quick 'jk' in insert mode fires escape

vim.keymap.set({ "n", "i", "v" }, "<leader>p", '"_dP', { desc = "Paste over" })
