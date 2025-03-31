return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		-- load the colorscheme here
		vim.o.background = "dark" -- or "light" for light mode
		vim.cmd([[colorscheme gruvbox]])
	end,
	opts = {},
}
