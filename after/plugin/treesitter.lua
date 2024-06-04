local status_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	print("treesitter configs not found!")
end

ts_configs.setup({
	ensure_installed = {
		"astro",
		"bash",
		"css",
		"go",
		"html",
		"json",
		"lua",
		"sql",
		"tsx",
		"yaml",
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	additional_vim_regex_highlighting = false,
	sync_install = false,
	ignore_install = {},
	modules = {},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
