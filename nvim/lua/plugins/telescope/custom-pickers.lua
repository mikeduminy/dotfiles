local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod
local actions = require("telescope.actions")

local M = {}

---Keep track of the active extension and folders for `live_grep`
local live_grep_filters = {
  ---@type nil|string
  extension = nil,
}

---Run `live_grep` with the active filters (extension and folders)
local function run_live_grep(current_input)
  require("telescope.builtin").live_grep({
    additional_args = live_grep_filters.extension and function()
      return { "-g", "*." .. live_grep_filters.extension }
    end,
    search_dirs = live_grep_filters.directories,
    default_text = current_input,
  })
end

M.actions = transform_mod({
  ---Ask for a file extension and open a new `live_grep` filtering by it
  set_extension = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local current_input = action_state.get_current_line()

    vim.ui.input({ prompt = "*." }, function(input)
      if input == nil then
        return
      end

      live_grep_filters.extension = input

      actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
      run_live_grep(current_input)
    end)
  end,
})

M.live_grep = function()
  live_grep_filters.extension = nil
  live_grep_filters.directories = nil

  require("telescope.builtin").live_grep()
end

return M
