--- Executes an LSP server command.
--- @param command string
--- @param args? lsp.LSPAny[]
local function execLspCommand(command, args)
  return function()
    vim.lsp.buf.execute_command({ command = command, arguments = args or nil })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>tsr", execLspCommand("typescript.restartTsServer") },
      { "<leader>tsl", execLspCommand("typescript.openTsServerLog") },
    },
    opts = {
      servers = {
        ["*"] = {
          capabilities = {
            general = {
              positionEncodings = { "utf-8" },
            },
          },
        },

        -- tsgo = {
        --   settings = {
        --     typescript = {
        --       inlayHints = {
        --         parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
        --         parameterTypes = { enabled = true },
        --         variableTypes = { enabled = false, suppressWhenTypeMatchesName = true },
        --         propertyDeclarationTypes = { enabled = false },
        --         functionLikeReturnTypes = { enabled = true },
        --         enumMemberValues = { enabled = true },
        --       },
        --     },
        --   },
        -- },
        --
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
            autoUseWorkspaceTsdk = true,
            typescript = {
              tsserver = {
                maxTsServerMemory = 12 * 1024,
              },
            },
          },
        },
      },
      setup = {
        eslint = function()
          require("snacks.util.lsp").on(function(buf, client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" or client.name == "vtsls" or client.name == "tsgo" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim" },
}
