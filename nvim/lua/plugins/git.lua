return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- The added file watcher is slow in monorepos, so we disable it by default
      watch_gitdir = {
        enable = false,
      },
    },
  },
}
