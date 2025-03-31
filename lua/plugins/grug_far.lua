return {
	"MagicDuck/grug-far.nvim",
	config = function()
		local current_project_root = vim.fn.getcwd()
		require("grug-far").setup({
			-- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
			prefills = {
				paths = current_project_root,
			},
		})
	end,
}
