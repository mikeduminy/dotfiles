local file = require("utils.file")

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

    require("telescope.builtin").live_grep({ search_dirs = { input } })
  end)
end

local openBuffers = function()
  require("telescope.builtin").buffers({ only_cwd = true })
end

local prevFiles = function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end

local files = function()
  require("lazyvim.util").telescope("find_files", { cwd = file.get_root() })()
end

local notifications = function()
  require("telescope").extensions.notify.notify()
end

local jumplist = function()
  require("telescope.builtin").jumplist()
end

local resumePicker = function()
  require("telescope.builtin").resume({ initial_mode = "normal" })
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

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", files, desc = "Find files" },
      { "<leader>fb", openBuffers, desc = "Buffers" },
      { "<leader>fo", prevFiles, desc = "Recent (old files)" },
      { "<leader>f/", liveGrepRelative, desc = "Find in Files (Grep)" },
      { "<leader>fr", resumePicker, desc = "Resume Last Picker" },
      { "<leader>sN", notifications, desc = "Notifications" },
      { "<leader>sj", jumplist, desc = "Jumplist" },
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
        },
        file_ignore_patterns = { "neo-tree ", "oil://" },
      },
      pickers = {
        buffers = {
          theme = "dropdown",
          initial_mode = "insert",
          preview = {
            hide_on_startup = true,
          },
          ignore_current_buffer = true,
          show_all_buffers = false, -- ignore unloaded buffers
          sort_lastused = true,
          sort_mru = true,
        },
        live_grep = {
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
        old_files = {
          initial_mode = "normal",
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
        "<leader>u",
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
}
