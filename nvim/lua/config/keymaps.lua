-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-----------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------
vim.keymap.set("n", "<Leader>n", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<Leader>N", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

vim.keymap.set({ "i" }, "jk", "<esc>") -- quick 'jk' in insert mode fires escape

-- safe paste
vim.keymap.set({ "n", "v" }, "<leader>p", '"_dP', { desc = "Paste over" })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>N", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- copy file path (relative)
vim.keymap.set("n", "<leader>cp", function() vim.fn.setreg("+",vim.fn.expand '%:~:.') end, { desc = "Copy Relative File Path" })
