local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
	return
end

whichkey.setup({
	preset = "modern",
	win = {
		border = "rounded",
		no_overlap = false,
		padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
		title = false,
		title_pos = "center",
		zindex = 1000,
	},
})

whichkey.add({
	{
		-- Normal and Visual Mode
		mode = { "n", "v" },
		{ "<leader>w", "<Cmd>update!<CR>", desc = "Save" },
		{ "<leader>q", "<Cmd>q!<CR>", desc = "Quit" },
		{
			"<leader>c",
			function()
				BufferDelete()
			end,
			desc = "Close",
		}, -- Keeps split window layout when closing buffer
		{ "<leader>C", "<Cmd>%bd|e#|bd#<CR>", desc = "Close Others" },
		{ "<leader>a", "<Cmd>Alpha<CR>", desc = "Alpha" },
		{ "<leader>e", "<Cmd>Telescop file_browser<CR>", desc = "Explorer" },
		{ "<leader>h", "<Cmd>Telescope command_history theme=dropdown<CR>", desc = "Command History" },
		{ "<leader>p", "<Cmd>Telescope find_files theme=dropdown<CR>", desc = "Open file" },
		{ "<leader>r", "<Cmd>Telescope oldfiles theme=dropdown previewer=false<CR>", desc = "Open recent file" },
		{ "<leader>F", "<Cmd>lua vim.lsp.buf.format()<CR>", desc = "Format Buffer" },
		{ "<leader>nn", "<Cmd>NoNeckPain<CR>", desc = "No neck pain" },
		{ "<leader>m", "<Cmd>Mason<CR>", desc = "Mason" },
		{ "-", "<Cmd>Oil<CR>", desc = "Open parent directory" },
		-- Buffer
		{ "<leader>b", group = "Buffer" },
		{ "<leader>bl", "<Cmd>Telescope buffers<CR>", desc = "List" },
		{ "<leader>bn", "<Cmd>enew<CR>", desc = "New" },
		{ "<leader>bh", "<Cmd>split<CR><C-w>w<CR>:b#<CR><C-w>p<CR>", desc = "Split horizontaly" },
		{ "<leader>bv", "<Cmd>vsplit<CR><C-w>w<CR>:b#<CR><C-w>p<CR>", desc = "Split verticaly" },
		-- Debugger
		{ "<leader>d", group = "Debugger" },
		{ "<leader>db", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Breakpoint" },
		{
			"<leader>dc",
			"<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
			desc = "Conditional breakpoint",
		},
		{
			"<leader>dm",
			"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
			desc = "Log point message",
		},
		{ "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", desc = "Repl" },
		{ "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", desc = "Run last" },
		-- Find
		{ "<leader>f", group = "Find" },
		{ "<leader>ff", "<Cmd>Telescope live_grep_args theme=ivy<CR>", desc = "String" },
		{ "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Keymap" },
		{ "<leader>fm", "<Cmd>Telescope man_pages<CR>", desc = "Man page" },
		{ "<leader>fp", "<Cmd>Telescope project<CR>", desc = "Project" },
		{ "<leader>fr", "<Cmd>Telescope repo list<CR>", desc = "Repo" },
		{ "<leader>fe", "<Cmd>Telescope env<CR>", desc = "Enviroment variable" },
		{ "<leader>ft", "<CMD>TodoTelescope<CR>", desc = "Open todo list" },
		-- Git
		{ "<leader>g", group = "Git" },
		{ "<leader>gd", "<CMD>lua ToggleDiffView()<CR>", desc = "Diff" },
		{ "<leader>gl", "<CMD>DiffviewLog<CR>", desc = "Log" },
		{ "<leader>gh", "<CMD>DiffviewFileHistory<CR>", desc = "History" },
		{ "<leader>gf", "<CMD>DiffviewFileHistory %<CR>", desc = "Curent file history" },
		-- Plugins
		{ "<leader>P", group = "Plugins" },
		{ "<leader>Ps", "<CMD>PackerSync<CR>", desc = "Sync" },
		{ "<leader>Pu", "<CMD>PackerUpdate<CR>", desc = "Update" },
		{ "<leader>Pl", "<CMD>PackerStatus<CR>", desc = "List" },
		-- Todo Comments
		{ "]t", "<CMD>lua require'todo-comments'.jump_next()<CR>", desc = "Next todo comment" },
		{ "[t", "<CMD>lua require'todo-comments'.jump_prev()<CR>", desc = "Previous todo comment" },
		-- Terminal
		{ "<leader>t", "<CMD>ToggleTerm<CR>", desc = "Terminal" },
	},
})

-- == Helper functions == --

function ToggleDiffView()
	if next(require("diffview.lib").views) == nil then
		-- Open diff view if it's not open
		vim.cmd("DiffviewOpen")
	else
		-- Close diff view if it's already open
		vim.cmd("DiffviewClose")
	end
end

function BufferDelete()
	local current_buffer = vim.api.nvim_get_current_buf()

	if vim.api.nvim_get_option_value("modified", { buf = current_buffer }) then
		local choice = vim.fn.confirm("Buffer is modified. Save changes?", "&Yes\n&No\n&Cancel", 1)

		if choice == 1 then
			vim.cmd("write")
		elseif choice == 3 then
			return
		end

		vim.cmd("bdelete!")
	else
		local buffers = vim.fn.getbufinfo({ buflisted = 1 })
		local total_nr_buffers = #buffers

		if total_nr_buffers == 1 then
			vim.cmd("bdelete")
			vim.cmd("enew") -- Create a new empty buffer if no other listed buffer exists
		else
			vim.cmd("bprevious")
			vim.cmd("bdelete #")
		end
	end
end
