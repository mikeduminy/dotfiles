local file = require("utils.file")

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

    local short_folder_name = Snacks.picker.util.truncate(input, 10)

    Snacks.picker.grep({ cwd = input, title = "Grep in folder - " .. short_folder_name })
  end)
end

local buffers = function()
  Snacks.picker.buffers({
    current = false, -- hide the current buffer in the list
    nofile = false, -- hide `buftype=nofile` buffers
    filter = {
      cwd = true,
      filter = function(item, filter)
        -- skip oil buffers
        if item.file:sub(1, 6) == "oil://" then
          return false
        end

        -- Temporarily unset self.opts.filter to prevent recursion
        local original_filter = filter.opts.filter
        filter.opts.filter = nil

        local result = filter:match(item)

        -- Restore self.opts.filter after the call
        filter.opts.filter = original_filter

        return result
      end,
    },
  })
end

-- find files in the directory of the buffer
local find_files = function()
  Snacks.picker.files({ cwd = file.get_root() })
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

    local short_folder_name = Snacks.picker.util.truncate(input, 10)

    Snacks.picker.files({ cwd = input, title = "Find files - " .. short_folder_name })
  end)
end

local resume = function()
  Snacks.picker.resume()
end

local recent_files_proj = function()
  Snacks.picker.recent({
    cwd = file.get_root(),
    title = "Recent (project)",
    filter = {
      cwd = true,
    },
  })
end

local recent_files_all = function()
  Snacks.picker.recent({
    title = "Recent (all)",
  })
end

local projects = function()
  Snacks.picker.projects({
    layout = "vscode",
  })
end

local smart = function()
  Snacks.picker.smart({
    title = "Smart search",
  })
end

local pickers = function()
  Snacks.picker.pickers({
    title = "Snacks pickers",
  })
end

local function_symbols = function()
  Snacks.picker.lsp_symbols({
    title = "Symbols (functions)",
    filter = {
      default = {
        "Function",
        "Method",
      },
    },
  })
end

return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        preview = function()
          return false
        end,
        layout = "select",
        sources = {
          files = {
            hidden = true, -- show hidden files
            exclude = { ".git", "node_modules", "vendor" }, -- exclude these folders
          },
        },
        layouts = {
          select = {
            layout = {
              width = 0.8, -- width of the select layout
              height = 0.8, -- height of the select layout
            },
          },
        },
        matcher = {
          frecency = true, -- enable frecency sorting
        },
        jump = {
          reuse_win = true, -- reuse the current window for the result
        },
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 40, -- truncate the file path to (roughly) this length
            git_status_hl = false,
          },
        },
        -- confirm = function(picker, item, action)
        --   -- Snacks.notify.info("Item " .. vim.inspect(item))
        --   -- Snacks.notify.info("Action " .. vim.inspect(action))
        --   -- Snacks.notify.info("Current buffer " .. vim.api.nvim_get_current_buf())
        --
        --   Snacks.picker.actions.jump(picker, item, action)
        -- end,
        actions = {},
        win = {
          -- result list window
          list = {
            keys = {
              -- splits
              ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
              ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
              -- open in current buffer
              -- ["<CR>"] = { "confirm", cmd = "edit", mode = { "i", "n" } },
            },
          },
        },
      },
    },

    keys = {
      { "<leader><leader>", buffers, desc = "Find buffers" },
      { "<leader>ff", find_files, desc = "Find files" },
      { "<leader>fF", find_files_relative, desc = "Find files (relative)" },
      { "<leader>f/", grep_relative, desc = "Find in files (grep)" },
      { "<leader>fr", resume, desc = "Resume last picker" },
      { "<leader>fo", recent_files_proj, desc = "Recent files (project)" },
      { "<leader>fO", recent_files_all, desc = "Recent files (all)" },
      { "<leader>fs", smart, desc = "Smart search" },
      { "<leader>fp", pickers, desc = "Pickers" },
      { "<leader>fP", projects, desc = "Projects" },
      { "<leader>sf", function_symbols, desc = "Symbols (functions)" },
    },
  },
}
