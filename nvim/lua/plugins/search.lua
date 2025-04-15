return {
  require("plugins.search.snacks-picker"),
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
      jump = {
        nohlsearch = true,
        autojump = true,
      },
      label = {
        rainbow = {
          enabled = true,
        },
      },
    },
  },
}
