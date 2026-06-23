--- @type LazySpec
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }

      -- disable diagnostics and autoformat on markdown files by default
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.diagnostic.enable(false, { bufnr = 0 })
          vim.b.disable_autoformat = true
        end,
      })
    end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>md",
        "<cmd>MarkdownPreview<cr>",
        desc = "Toggle markdown preview",
      },
    },
  },
}
