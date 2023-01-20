local custom_pickers = require 'plugins.telescope.custom-pickers'
local actions = require 'telescope.actions'

local luacmd = require 'utils.keymaps'.luacmd
local register = require 'utils.keymaps'.register

local MAX_SIZE = 128 * 1024 -- 128kb

local findFiles = function()
  local cwd = vim.fn.getcwd()
  require("telescope.builtin").find_files({ search_dirs = { cwd } })
end

local liveGrep = function()
  local dir = vim.fn.getcwd()
  require("telescope.builtin").live_grep({ search_dirs = { cwd = dir } })
end

local openBuffers = function()
  require("telescope.builtin").buffers({ only_cwd = true })
end

local prevFiles = function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end

local liveGrepRelative = function()
  -- local current_file_path = file_utils.get_current_file({ absolute = true })
  local current_file_path = vim.fn.expand('%:p:h')

  vim.ui.input({ prompt = 'Live grep in folder: ', default = current_file_path, completion = 'dir' }, function(input)
    if input == nil then
      return
    end
    print('')

    require 'telescope.builtin'.live_grep({ search_dirs = { input } })
  end)
end

local mappings = {
  ['<leader>f'] = { name = 'Telescope - Files' },
  ['<leader>fb'] = { openBuffers, 'Search buffers' },
  ['<leader>ff'] = { liveGrep, "Live grep" },
  ['<leader>FF'] = { liveGrepRelative, 'Live grep with folder picker' },
  ['<leader>fg'] = { luacmd 'require("telescope.builtin").git_files()', 'Search git files' },
  ['<leader>fk'] = { findFiles, 'Find files' },
  ['<leader>fo'] = { prevFiles, 'Previous files' },
  ['<leader>fq'] = { luacmd 'require("telescope.builtin").quickfix()', 'Quickfix' },
  ['<leader>fr'] = { luacmd 'require("telescope.builtin").resume()', 'Resume last picker' },
  ['<leader>s'] = { name = 'Telescope - Other' },
  ['<leader>sE'] = { luacmd 'require("telescope.builtin").reloader()', 'Reload modules' },
  ['<leader>sc'] = { luacmd 'require("telescope.builtin").command_history()', 'Command history' },
  ['<leader>sF'] = { luacmd 'require("telescope.builtin").filetypes()', 'Choose filetype' },
  ['<leader>sh'] = { luacmd 'require("telescope.builtin").help_tags()', 'Search help tags' },
  ['<leader>sm'] = { luacmd 'require("telescope.builtin").keymaps()', 'Keymaps' },
  ['<leader>sp'] = { luacmd 'require("telescope.builtin").pickers()', 'Search pickers' },
  ['<leader>sr'] = { luacmd 'require("telescope.builtin").resume()', 'Resume last picker' },
  ['<leader>sR'] = { luacmd 'require("telescope.builtin").registers()', 'Registers' },
  ['<leader>p'] = { luacmd 'require("telescope.builtin").builtin()', 'Pick from pickers' }
}

local function custom_buffer_preview_maker(filepath, bufnr, opts)
  opts = opts or {}

  -- disable in large files
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > MAX_SIZE then
      return
    else
      require 'telescope.previewers'.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local function custom_mime_hook(filepath, bufnr, opts)
  local is_image = function(filepath)
    local image_extensions = { 'png', 'jpg' } -- Supported image formats
    local split_path = vim.split(filepath:lower(), '.', { plain = true })
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

local M = {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    {
      'nvim-telescope/telescope-file-browser.nvim', -- File browser extension for Telescope
    }
  },
  keys = mappings,
  init = function()
    register(mappings)
  end,
  config = function()
    require 'telescope'.setup {
      defaults = {
        mappings = {
          i = {
            ['<c-j>'] = actions.move_selection_next,
            ['<c-k>'] = actions.move_selection_previous,
            ['<c-t>'] = require 'trouble.providers.telescope'.open_with_trouble,
            ["<M-p>"] = require 'telescope.actions.layout'.toggle_preview,
          },
          n = {
            ['<c-j>'] = actions.move_selection_next,
            ['<c-k>'] = actions.move_selection_previous,
            ['<c-t>'] = require 'trouble.providers.telescope'.open_with_trouble,
            ["<M-p>"] = require 'telescope.actions.layout'.toggle_preview,
          },
        },
        file_ignore_patterns = { '.git/' },
        cache_picker = {
          num_pickers = 10,
          limit_entries = 1000,
        },
        layout_strategy = 'bottom_pane',
        sorting_strategy = 'ascending',
        buffer_previewer_maker = custom_buffer_preview_maker,
        preview = {
          filesize_limit = MAX_SIZE,
          mime_hook = custom_mime_hook,
          treesitter = false,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          theme = 'ivy',
        },
        git_files = {
          prompt_prefix = 'Git>',
          theme = 'ivy',
        },
        live_grep = {
          theme = "ivy",
          path_display = { 'smart' },
          mappings = {
            i = {
              ['<c-f>'] = custom_pickers.actions.set_extension,
              -- ['<c-l>'] = custom_pickers.actions.set_folders,
            }
          }
        },
        buffers = {
          theme = 'dropdown',
          initial_mode = 'normal',
          preview = {
            hide_on_startup = true,
          },
          ignore_current_buffer = true,
        },
        help_tags = {
          theme = 'ivy',
        },
        old_files = {
          theme = 'ivy',
          initial_mode = 'normal',
        },
      },
      extensions = {
        file_browser = {
          theme = 'ivy',
        },
      },
    }

    require 'telescope'.load_extension 'fzf'
    require 'telescope'.load_extension "file_browser"
  end
}

return M
