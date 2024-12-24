return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	opts = {
		virtual_text = {
			enabled = true,
			key_bindings = {
				-- Accept the current completion.
				accept = "<C-j>",
				-- Accept the next word.
				accept_word = false,
				-- Accept the next line.
				accept_line = false,
				-- Clear the virtual text.
				clear = false,
				-- Cycle to the next completion.
				next = "<M-]>",
				-- Cycle to the previous completion.
				prev = "<M-[>",
			},
		},
		workspace = {
			use_lsp = true,
			paths = {
				".git",
				"package.json",
			},
		},
	},
}
