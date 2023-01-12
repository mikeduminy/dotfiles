-- Leader set to <space>
--- Note: must be set before we load plugins
vim.g.mapleader = ' '

require 'setup'
require 'options'
require 'plugins'

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require 'mappings'
	end,
})
