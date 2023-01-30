return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    winbar = {
      lualine_a = { "diagnostics" },
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = { "diagnostics" },
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {},
      lualine_z = {},
    },
    extensions = { "neo-tree" },
  },
}
