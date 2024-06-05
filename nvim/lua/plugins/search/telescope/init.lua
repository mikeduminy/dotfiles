local file = require("utils.file")

local getPickers = function()
  local builtins = require("telescope.builtin")
  return builtins
end

local liveGrepRelative = function()
  local current_path = file.get_current_dir()

  if current_path:sub(1, 6) == "oil://" then
    -- trim oil:// from start
    current_path = current_path:sub(7)
  end

  vim.ui.input({ prompt = "Live grep in folder: ", default = current_path, completion = "dir" }, function(input)
    if input == nil then
      return
    end

    getPickers().live_grep({ search_dirs = { input } })
  end)
end

local files = function()
  require("lazyvim.util").telescope("find_files", { cwd = file.get_root() })()
end

local filesRelative = function()
  local current_path = file.get_current_dir()

  if current_path:sub(1, 6) == "oil://" then
    -- trim oil:// from start
    current_path = current_path:sub(7)
  end

  vim.ui.input({ prompt = "Find files in folder: ", default = current_path, completion = "dir" }, function(input)
    if input == nil then
      return
    end

    getPickers().find_files({ search_dirs = { input } })
  end)
end

local notifications = function()
  require("telescope").extensions.notify.notify()
end

local MAX_SIZE = 128 * 1024 -- 128kb

local function custom_mime_hook(filepath, bufnr, opts)
  local is_image = function(filepath)
    local image_extensions = { "png", "jpg" } -- Supported image formats
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(image_extensions, extension)
  end
  if is_image(filepath) then
    -- ## Uncomment to support image preview
    -- local term = vim.api.nvim_open_term(bufnr, {})
    -- local function send_output(_, data, _)
    --   for _, d in ipairs(data) do
    --     vim.api.nvim_chan_send(term, d .. '\r\n')
    --   end
    -- end

    -- vim.fn.jobstart(
    --   {
    --     'catimg', filepath -- Terminal image viewer command
    --   },
    --   { on_stdout = send_output, stdout_buffered = true })
    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Image cannot be previewed")
  else
    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
  end
end

local default_layout_config = {
  anchor = "N",
  width = function(self, max_columns, max_lines)
    -- this function is called every time the picker is drawn
    local percent = 0.8
    local max_width = math.min(120, max_columns)
    local min_width = math.min(120, max_columns - 20)
    return math.min(math.max(math.floor(max_columns * percent), max_width), min_width)
  end,
  height = function(self, max_columns, max_lines)
    -- this function is called every time the picker is drawn
    -- vim.notify(vim.inspect({ max_columns = max_columns, max_lines = max_lines }))
    local percent = 0.3
    local max_height = math.min(20, max_lines)
    local min_height = math.min(20, max_lines - 5)
    return math.min(math.max(math.floor(max_lines * percent), max_height), min_height)
  end,
}

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><leader>", files, desc = "Find files" },
      { "<leader>ff", files, desc = "Find files" },
      { "<leader>fF", filesRelative, desc = "Find files (relative)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      -- { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent (old files)" },
      { "<leader>f/", liveGrepRelative, desc = "Find in Files (Grep)" },
      { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume Last Picker" },
      { "<leader>sN", notifications, desc = "Notifications" },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    opts = {
      defaults = {
        -- enable the following if telescope hangs when previewing large files
        -- buffer_previewer_maker = custom_buffer_preview_maker,
        preview = {
          filesize_limit = MAX_SIZE,
          treesitter = false,
          mime_hook = custom_mime_hook,
          hide_on_startup = true,
        },
        file_ignore_patterns = { "neo-tree ", "oil://" },
        cache_picker = {
          num_pickers = 10,
        },
        layout_strategy = "vertical",
        layout_config = {
          anchor = "N",
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          layout_config = default_layout_config,
          mappings = {},
        },
        resume = {
          theme = "dropdown",
          layout_config = default_layout_config,
          initial_mode = "normal",
        },
        jumplist = {
          theme = "dropdown",
          layout_config = default_layout_config,
          initial_mode = "normal",
        },
        buffers = {
          layout_config = default_layout_config,
          theme = "dropdown",
          only_cwd = true,
          ignore_current_buffer = true,
          show_all_buffers = false, -- ignore unloaded buffers
          sort_lastused = true,
          sort_mru = true,
          mappings = {
            i = {
              ["<c-d>"] = require("telescope.actions").delete_buffer,
            },
            n = {
              ["<c-d>"] = require("telescope.actions").delete_buffer,
            },
          },
        },
        oldfiles = {
          theme = "dropdown",
          layout_config = default_layout_config,
          initial_mode = "insert",
          only_cwd = true,
          mappings = {
            n = {
              ["<S-p>"] = require("telescope.actions.layout").toggle_preview,
            },
          },
        },
        live_grep = {
          theme = "dropdown",
          layout_config = default_layout_config,
          path_display = { shorten = { len = 4, exclude = { 1, -1 } } },
          mappings = {
            i = {
              -- filter live_grep by file extension
              ["<c-f>"] = require("plugins.search.telescope.custom-pickers").actions.set_extension,
            },
          },
          additional_args = function(opts)
            return { "--smart-case", "--hidden" }
          end,
        },
      },
      extensions = { "notify" },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>fu",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      extensions = {
        undo = {
          use_delta = true,
        },
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    keys = {
      {
        "<leader>fo",
        "<cmd>Telescope frecency theme=dropdown<cr>",
        desc = "Frecent Files",
      },
    },
    opts = {
      extensions = {
        frecency = {
          hide_current_buffer = true, -- Do not show the current buffer
          default_workspace = "CWD", -- Use the current working directory
          db_safe_mode = false, -- Do not prompt to remove entries from the database
          show_unindexed = false, -- Do not include unindexed files
          path_display = { shorten = { len = 4, exclude = { 1, -1 } } },
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("frecency")
    end,
  },
}
