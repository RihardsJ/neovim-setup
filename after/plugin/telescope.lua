local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	print("telescope not found!")
	return
end

-- == Setup == --
telescope.setup({
	extensions = {
		file_browser = {
			theme = "dropdown",
			hijack_netrw = true,
			grouped = true,
			hidden = false,
			initial_mode = "normal",
			path = "%:p:h select_buffer=true",
		},
	},
})

-- == Extensions == --
require("telescope").load_extension("env")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("project")
require("telescope").load_extension("projects")
require("telescope").load_extension("repo")
