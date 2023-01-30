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
  },
}
