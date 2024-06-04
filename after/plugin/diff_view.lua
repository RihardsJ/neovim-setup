local status_ok, diff_view = pcall(require, "diffview")
if not status_ok then
	return
end

diff_view.setup({
	file_panel = {
		listing_style = "list", -- One of 'list' or 'tree'
	},
})

-- == Refresh diff_view after commit == --
vim.cmd([[
  autocmd BufWritePost * DiffviewRefresh
]])
