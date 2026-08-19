--- Executes an LSP server command.
--- @param command string
--- @param args? lsp.LSPAny[]
local function execLspCommand(command, args)
  return function()
    vim.lsp.buf.execute_command({ command = command, arguments = args or nil })
  end
end

vim.g.lazyvim_ts_lsp = "tsgo"

--- @type LazySpec
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

        tsgo = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "none", suppressWhenArgumentMatchesName = true },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false, suppressWhenTypeMatchesName = true },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              customTags = {
                "!reference sequence",
              },
              schemas = {
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                  ".gitlab-ci.yml",
                  ".gitlab/**/*.yml",
                },
              },
            },
          },
        },
      },
      setup = {
        eslint = function()
          require("snacks.util.lsp").on(function(buf, client)
            if client.name == "tsserver" or client.name == "vtsls" or client.name == "tsgo" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim" },
}
