return {
	"stevearc/oil.nvim",
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	opts = {
		view_options = {
			show_hidden = true,
		},
		keymaps = {
			-- create a new mapping, gs, to search and replace in the current directory
			fs = {
				callback = function()
					-- get the current directory
					local prefills = { paths = require("oil").get_current_dir() }
					local grug_far = require("grug-far")
					-- instance check
					if not grug_far.has_instance("explorer") then
						grug_far.open({
							instanceName = "explorer",
							prefills = prefills,
							staticTitle = "Find and Replace from Explorer",
						})
					else
						grug_far.open_instance("explorer")
						-- updating the prefills without clearing the search and other fields
						grug_far.update_instance_prefills("explorer", prefills, false)
					end
				end,
				desc = "oil: Search in directory",
			},
		},
	},
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
}
