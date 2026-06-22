-- disabled openai_fim_compatible ollama config in favor of claude-haiku-4-5 via
-- local proxy
local ollamaLocalConfig = {
  -- Ollama's local address
  end_point = "http://localhost:11434/v1/completions",

  -- For local Ollama, you don't need a real key; use any string placeholder
  api_key = function()
    return "noop"
  end,

  name = "Ollama",
  -- Match the exact model name pulled via `ollama pull`
  model = "qwen2.5-coder:1.5b",
  stream = true,
  optional = {
    max_tokens = 256,
    temperature = 0.2,
  },
}

--- @type LazySpec
return {
  {
    "saghen/blink.cmp",
    dependencies = { "milanglacier/minuet-ai.nvim" },
    opts = {
      keymap = {
        -- Manually invoke minuet completion.
        ["<C-h>"] = {
          -- return value of require('minuet').make_blink_map(), but doesn't
          -- require it to be loaded before
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            async = true,
            -- Should match minuet.config.request_timeout * 1000,
            -- since minuet.config.request_timeout is in seconds
            timeout_ms = 3000,
            score_offset = 50, -- Gives minuet higher priority among suggestions
          },
        },
      },
      completion = { trigger = { prefetch_on_insert = false } },
    },
  },
  {
    "milanglacier/minuet-ai.nvim",
    events = { "InsertEnter", "CmdlineEnter", "VeryLazy" },
    commands = { "Minuet" },
    keys = { { "<leader>avt", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle virtualtext autocomplete" } },
    -- note: requires ollama running the specified model below
    opts = {
      -- avoid race-condition inside plugin which curls Ollama too many times and causes errors
      -- n_completions = 1,
      blink = {
        enable_auto_complete = true,
      },

      provider = "openai_fim_compatible",

      provider_options = {
        -- use fim (fill-in-middle) even though claude doesn't support it
        -- because it feels cleaner than relying on the chat API
        openai_fim_compatible = {
          name = "LiteLLM - Claude Haiku",
          model = "claude-haiku-4-5",
          stream = true,

          -- Local proxy for liteLLM
          end_point = "http://localhost:1337/v1/completions",
          -- no API key is needed
          api_key = function()
            return "noop"
          end,

          optional = {
            max_tokens = 256,
            temperature = 0.2,
            stop = { "```" },
          },

          template = {
            prompt = function(context_before_cursor, context_after_cursor)
              -- custom prompt to help claude support FIM
              return "You are a code completion engine. Insert ONLY the code that belongs at <CURSOR>. Do not repeat code before or after the cursor. Do not close brackets or blocks that are already closed after the cursor. No markdown. No backticks. No explanation.\n\n"
                .. context_before_cursor
                .. "<CURSOR>"
                .. context_after_cursor
                .. "\n\nInsertion at <CURSOR>:"
            end,
            suffix = false,
          },

          -- specific to LiteLLM
          get_text_fn = {
            no_stream = function(json)
              return json.choices[1].text
            end,
            stream = function(json)
              return json.choices and json.choices[1] and json.choices[1].text or ""
            end,
          },
        },
      },

      lsp = {
        enable = true,
      },

      -- 2. Configure how completions are triggered and accepted
      virtualtext = {
        -- Set to empty {} if you only want manual trigger,
        -- or add filetypes like { "lua", "python", "javascript" } for auto-trigger
        auto_trigger_ft = { "lua", "javascript", "rust", "go", "python", "bash", "zsh", "typescript" },
        keymap = {
          accept = "<Tab>", -- Accept whole suggestion (Option + Shift + A on Mac)
          accept_line = "<A-a>", -- Accept only the current line (Option + A on Mac)
          dismiss = "<A-e>", -- Clear the current ghost text
          next = "<A-]>", -- Cycle forward through suggestions
          prev = "<A-[>", -- Cycle backward through suggestions
        },
        show_on_completion_menu = false,
      },
    },
  },
}
