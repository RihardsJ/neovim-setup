local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
	return
end

local conf = {
	window = {
		border = "shadow", -- none, single, double, shadow
		position = "top", -- bottom, top
	},
}

local options = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local ToggleNertw = require("utils.nertw-toggle")
local keymaps = {
	["w"] = { "<Cmd>update!<Cr>", "Save" },
	["q"] = { "<Cmd>q!<Cr>", "Quit" },
	["c"] = { "<Cmd>bd!<Cr>", "Close" },
	["C"] = { "<Cmd>%bd|e#|bd#<Cr>", "Close Others" },
	["a"] = { "<Cmd>Alpha<Cr>", "Alpha" },
	["e"] = { ToggleNertw, "Explorer" },
	["m"] = { "<Cmd>Mason<Cr>", "Mason" },
	["h"] = { "<Cmd>Telescope command_history theme=dropdown<Cr>", "History" },
	["p"] = { "<Cmd>Telescope find_files theme=dropdown<Cr>", "Open File" },
	["r"] = { "<Cmd>Telescope oldfiles theme=dropdown previewer=false<Cr>", "Recent Files" },
	["f"] = { "<Cmd>lua vim.lsp.buf.format()<Cr>", "format" },
	["nn"] = { "<Cmd>NoNeckPain<Cr>", "no neck pain" },
	["t"] = { "<Cmd>10split term://zsh<Cr>", "terminal" },
	B = {
		name = "Buffer",
		l = { "<Cmd>Telescope buffers<Cr>", "list" },
		n = { "<Cmd>enew<Cr>", "open new" },
	},
	F = {
		name = "Find",
		s = { "<Cmd>Telescope live_grep theme=ivy<Cr>", "string" },
		m = { "<Cmd>Telescope man_pages<Cr>", "man page" },
		p = { "<Cmd>Telescope project<Cr>", "project" },
		r = { "<Cmd>Telescope repo list<Cr>", "repo" },
		e = { "<Cmd>Telescope env<Cr>", "env" },
	},
	P = {
		name = "Packer",
		c = { "<Cmd>PackerCompile<Cr>", "compile" },
		i = { "<Cmd>PackerInstall<Cr>", "install" },
		s = { "<Cmd>PackerSync<Cr>", "sync" },
		S = { "<Cmd>PackerStatus<Cr>", "status" },
		u = { "<Cmd>PackerUpdate<Cr>", "update" },
	},
}

whichkey.setup(conf)
whichkey.register(keymaps, options)
