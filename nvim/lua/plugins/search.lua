return {
  require("plugins.search.telescope"),
  {
    "folke/flash.nvim",
    opts = {
      search = {
        mode = "search",
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
