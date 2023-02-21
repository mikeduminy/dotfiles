return {
  "numToStr/Navigator.nvim",
  event = "WinEnter",
  keys = {
    {
      "<C-h>",
      function()
        require("Navigator").left()
      end,
      { desc = "Go to left window" },
    },
    {
      "<C-j>",
      function()
        require("Navigator").down()
      end,
      { desc = "Go to lower window" },
    },
    {
      "<C-k>",
      function()
        require("Navigator").up()
      end,
      { desc = "Go to upper window" },
    },
    {
      "<C-l>",
      function()
        require("Navigator").right()
      end,
      { desc = "Go to right window" },
    },
  },
  config = true,
}
-- require('Navigator').previous()
