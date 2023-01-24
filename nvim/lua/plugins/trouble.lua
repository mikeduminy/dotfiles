return {
  "folke/trouble.nvim",
  keys = {
    {
      "<leader>xn",
      function()
        require("trouble").next({ skip_groups = true, jump = true })
      end,
      desc = "Next Diagnostic (Trouble)",
    },
    {
      "<leader>xN",
      function()
        require("trouble").previous({ skip_groups = true, jump = true })
      end,
      desc = "Previous Diagnostic (Trouble)",
    },
  },
}
