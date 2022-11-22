local plugin = require('auto-session')

plugin.setup({
  auto_session_suppress_dirs = { "~/", "~/Klarna", "~/source", "~/Downloads", "/" },
  cwd_change_handling = {
    post_cwd_changed_hook = function()
      -- refresh lualine so the new session name is displayed in the status bar
      require('lualine').refresh()
    end
  }
})
