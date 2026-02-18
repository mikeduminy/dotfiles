return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    init = function()
      -- don't wrap when navigating to panes with the cursor at the border
      vim.g.tmux_navigator_no_wrap = 1
    end,
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- {
  --   "numToStr/Navigator.nvim",
  --   event = "WinEnter",
  --   keys = {
  --     {
  --       "<C-h>",
  --       function()
  --         require("Navigator").left()
  --       end,
  --       { desc = "Go to left window" },
  --     },
  --     {
  --       "<C-j>",
  --       function()
  --         require("Navigator").down()
  --       end,
  --       { desc = "Go to lower window" },
  --     },
  --     {
  --       "<C-k>",
  --       function()
  --         require("Navigator").up()
  --       end,
  --       { desc = "Go to upper window" },
  --     },
  --     {
  --       "<C-l>",
  --       function()
  --         require("Navigator").right()
  --       end,
  --       { desc = "Go to right window" },
  --     },
  --   },
  --   config = true,
  -- },
}
-- require('Navigator').previous()
