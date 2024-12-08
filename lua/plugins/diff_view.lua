-- == Refresh diff_view after commit == --
vim.cmd([[
  autocmd BufWritePost * DiffviewRefresh
]])

return {
	"sindrets/diffview.nvim",
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
	opts = {
		file_panel = {
			listing_style = "list", -- One of 'list' or 'tree'
		},
	},
}
