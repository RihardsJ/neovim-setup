local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
	return
end

-- Vim buffer settings to support fold
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]] -- make fold line to look nice
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Keymaps
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

local ftMap = {
	vim = "indent",
	python = { "indent" },
	git = "",
}

ufo.setup({
	open_fold_hl_timeout = 150,
	close_fold_kinds_for_ft = {
		default = { "imports", "comment" },
		json = { "array" },
		c = { "comment", "region" },
	},
	preview = {
		win_config = {
			border = { "", "─", "", "", "", "─", "", "" },
			winhighlight = "Normal:Folded",
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
			jumpTop = "[",
			jumpBot = "]",
		},
	},
	provider_selector = function(bufnr, filetype, buftype)
		-- if you prefer treesitter provider rather than lsp,
		-- return ftMap[filetype] or {'treesitter', 'indent'}
		return ftMap[filetype]

		-- refer to ./doc/example.lua for detail
	end,
})
