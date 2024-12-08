return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local nls = require("null-ls")
		-- == Auto formatting == --
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- == Setup == --
		local formatting = nls.builtins.formatting
		local diagnostics = nls.builtins.diagnostics
		-- local completion = null_ls.builtins.completion

		nls.setup({
			debug = true,
			sources = {
				formatting.stylua,
				formatting.prettierd.with({
					disabled_filetypes = {
						"markdown",
						"md",
					},
				}),
				formatting.stylelint,
				diagnostics.stylelint,

				require("none-ls.formatting.eslint_d").with({
					disabled_filetypes = {
						"markdown",
						"md",
					},
				}),
				require("none-ls.formatting.eslint_d").with({
					condition = function(utils)
						return utils.root_has_file({
							".eslintrc.js",
							".eslintrc.cjs",
							".eslintrc",
							"eslint.config.js",
							"eslint.config.mjs",
							"eslint.config.cjs",
						})
					end,
				}),
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
