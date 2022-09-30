local harpoonUI = require 'harpoon.ui'
local add_file = require 'harpoon.mark'.add_file

local toggle_quick_menu = harpoonUI.toggle_quick_menu
local nav_next = harpoonUI.nav_next
local nav_prev = harpoonUI.nav_prev

local M = {
  ['<leader>a'] = { name = 'Harpoon' },
  ['<leader>aa'] = { add_file, 'Harpoon - Add Mark' },
  ['<leader>af'] = { toggle_quick_menu, 'Harpoon - Show' },
  ['<leader>an'] = { nav_next, 'Harpoon - Next' },
  ['<leader>aN'] = { nav_prev, 'Harpoon - Previous' }
}

return M
