local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	print("telescope not found!")
	return
end

-- == Extensions == --

-- == Setup == --
-- local actions = require"telescope.actions"

telescope.setup({
	extensions = {
		file_browser = {
			theme = "dropdown",
			hijack_netrw = true,
			grouped = true,
			hidden = true,
			initial_mode = "normal",
			path = "%:p:h select_buffer=true",
		},
	},
})

require("telescope").load_extension("project")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("env")
require("telescope").load_extension("repo")
require("telescope").load_extension("fzf")
