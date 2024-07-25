local file = require("utils.file")

vim.g.lazyvim_picker = "fzf"

local get_pickers = function()
  local builtins = require("fzf-lua")
  return {
    live_grep = builtins.live_grep_native,
    find_files = builtins.files,
  }
end

local grep_relative = function()
  local current_path = file.get_current_dir()

  if current_path:sub(1, 6) == "oil://" then
    -- trim oil:// from start
    current_path = current_path:sub(7)
  end

  vim.ui.input({ prompt = "Live grep in folder: ", default = current_path, completion = "dir" }, function(input)
    if input == nil then
      return
    end

    get_pickers().live_grep({ cwd = input })
  end)
end

local buffers = function()
  require("fzf-lua").buffers()
end

-- find files in the directory of the buffer
local find_files = function()
  require("lazyvim.util.pick").open("files", { cwd = file.get_root() })
end

local find_files_relative = function()
  local current_path = file.get_current_dir()

  if current_path:sub(1, 6) == "oil://" then
    -- trim oil:// from start
    current_path = current_path:sub(7)
  end

  vim.ui.input({ prompt = "Find files in folder: ", default = current_path, completion = "dir" }, function(input)
    if input == nil then
      return
    end

    get_pickers().find_files({ cwd = input })
  end)
end

local resume = function()
  require("fzf-lua").resume()
end

local old_files = function()
  require("fzf-lua").oldfiles({ cwd = file.get_root() })
end

local pickers = function()
  require("fzf-lua").builtin()
end

return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      -- set profile
      table.insert(opts, 1, "fzf-native")

      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          previewer = false,
          git_icons = false,
        },
      })
    end,
    keys = {
      { "<leader><leader>", buffers, desc = "Find buffers" },
      { "<leader>ff", find_files, desc = "Find files" },
      { "<leader>fF", find_files_relative, desc = "Find files (relative)" },
      { "<leader>f/", grep_relative, desc = "Find in Files (Grep)" },
      { "<leader>fr", resume, desc = "Resume last picker" },
      { "<leader>fo", old_files, desc = "Old files" },
      { "<leader>fP", pickers, desc = "Pickers" },
    },
  },
}
