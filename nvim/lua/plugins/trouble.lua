local function next_group() end

--- @type LazyPluginSpec
return {
  "folke/trouble.nvim",
  -- keys = {
  --   {
  --     "<leader>xn",
  --     function()
  --       require("trouble").next({ skip_groups = true, jump = true })
  --     end,
  --     desc = "Next Diagnostic (Trouble)",
  --   },
  --   {
  --     "<leader>xN",
  --     function()
  --       require("trouble").prev({ skip_groups = true, jump = true })
  --     end,
  --     desc = "Previous Diagnostic (Trouble)",
  --   },
  -- },
  opts = {
    --- @type table<string, trouble.Action>
    keys = {
      s = {
        action = function(view, ctx)
          local cursor = vim.api.nvim_win_get_cursor(view.win.win)
          vim.notify("cursor is at " .. cursor[1] .. ":" .. cursor[2])
          -- -- only run for quickfix
          -- local f = view:get_filter("severity")
          -- local severity = ((f and f.filter.severity or 0) + 1) % 5
          -- view:filter({ severity = severity }, {
          --   id = "severity",
          --   template = "{hl:Title}Filter:{hl} {severity}",
          --   del = severity == 0,
          -- })
        end,
        desc = "Toggle Severity Filter",
      },
    },
  },
}
