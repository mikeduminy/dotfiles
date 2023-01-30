return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- vtsls = {},
      tsserver = {
        init_options = {
          -- support large TS projects
          maxTsServerMemory = 8192,
        },
      },
      eslint = {},
    },
  },
}
