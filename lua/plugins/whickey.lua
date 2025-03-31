local keymaps = {
	{
		"<leader>?",
		function()
			require("which-key").show({ global = false })
		end,
		desc = "Buffer Keymaps",
	},
	{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
	{ "<leader>W", "<cmd>wa<cr>", desc = "Write all" },
	{ "<leader>q", "<cmd>lua QuitWithPrompt()<cr>", desc = "Quit" },
	{ "<leader>Q", "<cmd>q!<cr>", desc = "Force Quit" },
	{ "<leader>c", "<cmd>lua BufferDelete()<CR>", desc = "Close" },
	{
		"<leader>C",
		"<Cmd>BufferCloseAllButCurrent<CR>",
		desc = "Close Others",
	},
	--== Buffers ==--
	{ "<leader>b", group = "Buffer", desc = "Buffer" },
	{ "<leader>bn", "<cmd>enew<cr>", desc = "New buffer" },
	{ "<leader>bh", "<cmd>split<cr>", desc = "Split horizontal" },
	{ "<leader>bv", "<cmd>vsplit<cr>", desc = "Split vertical" },
	{ "<leader>br", "<cmd>BufferRestore<cr>", desc = "Restore" },
	{ "<leader>bp", "<cmd>BufferPick<cr>", desc = "Pick" },
	-- Buffer navigation
	{ "<A-,>", "<cmd>BufferPrevious<cr>", desc = "Previous buffer" },
	{ "<A-.>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
	{ "<A-<>", "<cmd>BufferMovePrevious<cr>", desc = "Move buffer left" },
	{ "<A->>", "<cmd>BufferMoveNext<cr>", desc = "Move buffer right" },
	--== Git ==--
	{ "<leader>g", group = "Git", desc = "Git" },
	{ "<leader>gd", "<CMD>lua ToggleDiffView()<CR>", desc = "Diff" },
	{ "<leader>gl", "<CMD>DiffviewLog<CR>", desc = "Log" },
	{ "<leader>gh", "<CMD>DiffviewFileHistory<CR>", desc = "History" },
	{
		"<leader>gf",
		"<cmd>DiffviewFileHistory %<cr>",
		desc = "Curent file history",
	},
	--== Todo Comments ==--
	{
		"]t",
		"<cmd>lua require'todo-comments'.jump_next()<CR>",
		desc = "Next todo comment",
	},
	{
		"[t",
		"<cmd>lua require'todo-comments'.jump_prev()<CR>",
		desc = "Previous todo comment",
	},
	--== Search ==--
	{ "<leader>f", group = "Find", desc = "Find" },
	-- GrugFar --
	{
		"<leader>fs",
		"<cmd>GrugFar<cr>",
		desc = "Find string",
	},
	-- Telescope --
	{
		"<leader>ff",
		"<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
		desc = "Find file",
	},
	{ "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find open buffer" },
	{
		"<leader>fc",
		"<cmd>Telescope commands<cr>",
		desc = "Find command",
	},
	{
		"<leader>fn",
		"<cmd>Telescope node_modules list<cr>",
		desc = "Find node module",
	},
	{
		"<leader>ft",
		"<cmd>TodoTelescope<cr>",
		desc = "Find todo comment",
	},
	{
		"<leader>fw",
		"<cmd>Telescope whaler<cr>",
		desc = "Find directory",
	},

	{
		"<leader>p",
		"<cmd>Telescope find_files hidden=true<cr>",
		desc = "Open File",
	},
	{
		"<leader>P",
		"<cmd>Telescope project<cr>",
		desc = "Open Project",
	},
	{
		"<leader>r",
		"<cmd>Telescope oldfiles<cr>",
		desc = "Open Recent Files",
	},
	-- Misc
	{
		"<leader>nn",
		"<cmd>NoNeckPain<cr>",
		desc = "No Neck Pain",
	},
}

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

function QuitWithPrompt()
	if vim.fn.getbufinfo({ bufmodified = 1 })[1] ~= nil then
		local choice = vim.fn.confirm("There are unsaved changes. Save before quitting?", "&Yes\n&No\n&Cancel", 1)
		if choice == 1 then -- Yes
			vim.cmd("wa")
			vim.cmd("qa")
		elseif choice == 2 then -- No
			vim.cmd("qa!")
		end
		-- Choice 3 (Cancel) does nothing
	else
		vim.cmd("qa")
	end
end

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	keys = keymaps,
}
