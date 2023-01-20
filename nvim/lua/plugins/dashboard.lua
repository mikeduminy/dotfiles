local M = {
  'glepnir/dashboard-nvim',
  init = function()
    local db = require 'dashboard'
    local configHome = os.getenv('XDG_CONFIG_HOME')

    db.session_directory = string.format("%s/nvim/sessions", os.getenv("XDG_CACHE_HOME"))

    db.custom_header = {
      '',
      ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
      ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
      ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
      ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
      ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
      ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
      '',
      vim.fn.getcwd(),
      ''
    }

    db.custom_center = {
      { icon = '  ',
        desc = 'Recently latest session',
        action = 'SessionLoad'
      },
      { icon = '  ',
        desc = 'Recently opened files',
        action = function()
          require("telescope.builtin").oldfiles({ layout_strategy = 'horizontal' })
        end,
      },
      { icon = '  ',
        desc = 'Find File',
        action = 'Telescope find_files find_command=rg,--hidden,--files',
      },
      { icon = '  ',
        desc = 'File Browser',
        action = 'Telescope file_browser',
      },
      { icon = '  ',
        desc = 'Find word',
        action = 'Telescope live_grep',
      },
      { icon = '  ',
        desc = 'Open Personal dotfiles',
        action = function()
          vim.cmd.cd(configHome)
          vim.cmd.edit('.')
        end,
      },
    }

    local function getFooter()
      local footer = {}
      if packer_plugins ~= nil then
        local pluginCount = #vim.tbl_keys(packer_plugins)
        local line = '🎉 ' .. pluginCount .. ' plugins'
        table.insert(footer, line)
      end

      return footer
    end

    db.custom_footer = getFooter
  end
}
return M
