return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    {
      "<leader>uz",
      function()
        require("zen-mode").toggle()
      end,
      desc = "Toggle Zen Mode 🧘",
    },
  },
  config = {
    window = {
      backdrop = 0.93,
      width = 0.85,
    },
    plugins = {
      -- this will change the font size on wezterm when in zen mode
      -- See alse also the Plugins/Wezterm section in this projects README
      wezterm = {
        enabled = true,
        -- can be either an absolute font size or the number of incremental steps
        font = "+4", -- (10% increase per step)
      },
    },
  },
}
