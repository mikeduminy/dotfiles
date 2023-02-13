return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    for _, section in pairs(opts.sections) do
      for _, v in ipairs(section) do
        if type(v) == "table" and vim.tbl_contains(v, "filename") then
          -- don't show full path in status line
          v.path = 0
        end
      end
    end

    return vim.tbl_deep_extend("force", opts, {
      winbar = {
        lualine_a = {},
        lualine_b = { { "diagnostics" } },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = { { "diagnostics" } },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
