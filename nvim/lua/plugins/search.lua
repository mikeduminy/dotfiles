return {
  require("plugins.search.fzf"),
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
