return {
  {
    "echasnovski/mini.animate",
    opts = function(_, opts)
      return vim.tbl_extend("force", opts, {
        cursor = {
          enable = false,
        },
      })
    end,
  },
}
