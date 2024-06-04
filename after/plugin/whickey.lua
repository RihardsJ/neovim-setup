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

local keymaps = {
	["w"] = { "<Cmd>update!<CR>", "Save" },
	["q"] = { "<Cmd>q!<CR>", "Quit" },
	["c"] = { "<Cmd>bd!<CR>", "Close" },
	["C"] = { "<Cmd>%bd|e#|bd#<CR>", "Close Others" },
	["a"] = { "<Cmd>Alpha<CR>", "Alpha" },
	["e"] = { "<Cmd>Telescop file_browser<CR>", "Explorer" },
	["m"] = { "<Cmd>Mason<CR>", "Mason" },
	["h"] = { "<Cmd>Telescope command_history theme=dropdown<CR>", "History" },
	["p"] = { "<Cmd>Telescope find_files theme=dropdown<CR>", "Open File" },
	["r"] = { "<Cmd>Telescope oldfiles theme=dropdown previewer=false<CR>", "Recent Files" },
	["F"] = { "<Cmd>lua vim.lsp.buf.format()<CR>", "format" },
	["t"] = { "<Cmd>ToggleTerm<CR>", "terminal" },
	["T"] = { "<Cmd>vsplit | terminal<CR>", "terminal buffer" },
	["nn"] = { "<Cmd>NoNeckPain<CR>", "no neck pain" },
	["ff"] = { "<Cmd>Telescope live_grep_args theme=ivy<CR>", "string" },

	b = {
		name = "Buffer",
		l = { "<Cmd>Telescope buffers<CR>", "list" },
		n = { "<Cmd>enew<CR>", "open new" },
		h = { "<Cmd>split<CR><C-w>w<CR>:b#<CR><C-w>p<CR>", "split horizontaly" },
		v = { "<Cmd>vsplit<CR><C-w>w<CR>:b#<CR><C-w>p<CR>", "split verticaly" },
	},
	d = {
		name = "Debugger",
		b = { "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", "toggle breakpoint" },
		B = {
			"<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
			"conditional brealpoint",
		},
		m = {
			"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
			"log point message",
		},
		o = { "<Cmd>lua require'dap'.repl.open()<CR>", "open repl" },
		l = { "<Cmd>lua require'dap'.run_last()<CR>", "run last" },
	},
	f = {
		name = "Find",
		k = { "<Cmd>Telescope keymaps<CR>", "keymaps" },
		m = { "<Cmd>Telescope man_pages<CR>", "man page" },
		p = { "<Cmd>Telescope project<CR>", "project" },
		r = { "<Cmd>Telescope repo list<CR>", "repo" },
		e = { "<Cmd>Telescope env<CR>", "env" },
	},
	g = {
		name = "Git",
		d = { ToggleDiffView(), "toggle diffview" },
		l = { "<CMD>DiffviewLog<CR>", "log" },
		h = { "<CMD>DiffviewFileHistory<CR>", "file history" },
		f = { "<CMD>DiffviewFileHistory %<CR>", "current file history" },
	},
	P = {
		name = "Plugins",
		c = { "<Cmd>PackerCompile<CR>", "compile" },
		i = { "<Cmd>PackerInstall<CR>", "install" },
		s = { "<Cmd>PackerSync<CR>", "sync" },
		S = { "<Cmd>PackerStatus<CR>", "status" },
		u = { "<Cmd>PackerUpdate<CR>", "update" },
	},
}

whichkey.setup(conf)
whichkey.register(keymaps, options)

-- == Helper functions == --

function ToggleDiffView()
	print("ToggleDiffView executed")
	if next(require("diffview.lib").views) == nil then
		-- Open diff view if it's not open
		vim.cmd("DiffviewOpen")
	else
		-- Close diff view if it's already open
		vim.cmd("DiffviewClose")
	end
end
