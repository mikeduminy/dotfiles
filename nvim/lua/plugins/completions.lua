return {
  {
    "milanglacier/minuet-ai.nvim",
    -- note: requires ollama running the specified model below
    config = function()
      require("minuet").setup({
        -- avoid race-condition inside plugin which curls Ollama too many times and causes errors
        n_completions = 1,

        context_window = 512,

        -- 1. Use the OpenAI FIM compatible protocol for Ollama
        provider = "openai_fim_compatible",
        provider_options = {
          openai_fim_compatible = {
            -- Ollama's local address
            end_point = "http://127.0.0.1:11434/v1/completions",

            -- For local Ollama, you don't need a real key; use any string placeholder
            api_key = "TERM",
            name = "Ollama",
            -- Match the exact model name pulled via `ollama pull`
            model = "qwen2.5-coder:1.5b",
            optional = {
              -- Tweak generation constraints if needed
              max_tokens = 128,
              temperature = 0.2,
            },
          },
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
        },
      })
    end,
  },
}
