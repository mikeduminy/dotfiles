return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- tsserver = {
        --   init_options = {
        --     -- support large TS projects
        --     maxTsServerMemory = 8192,
        --     -- disableAutomaticTypingAcquisition = true,
        --   },
        --   preferences = {
        --     includeCompletionsForModuleExports = false,
        --     includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        --   },
        -- },
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 6 * 1024,
              },
            },
          },
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" or client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
        -- eslint = function(_, opts)
        --   opts.capabilities.documentFormattingProvider = false
        -- end,
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim" },
}
