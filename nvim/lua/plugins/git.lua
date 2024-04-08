return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- The added file watcher is slow in monorepos, so we disable it by default
      watch_gitdir = {
        enable = false,
      },
    },
    keys = {
      {
        "<leader>gb",
        function()
          local gs = require("gitsigns")
          gs.toggle_current_line_blame()
        end,
        desc = "Toggle current line blame",
      },
    },
  },
}
