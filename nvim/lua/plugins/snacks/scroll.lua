return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    scroll = {
      filter = function()
        -- disable scroll animations
        return false
      end,
    },
  },
}
