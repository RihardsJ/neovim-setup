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

		local lsp_formatting = function(bufnr)
			vim.lsp.buf.format({
				filter = function(client)
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end

		local function is_null_ls_formatting_enabled(bufnr)
			local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
			local generators =
				require("null-ls.generators").get_available(file_type, require("null-ls.methods").internal.FORMATTING)
			return #generators > 0
		end

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
				if client.server_capabilities.documentFormattingProvider then
					if
						client.name == "null-ls" and is_null_ls_formatting_enabled(bufnr)
						or client.name ~= "null-ls"
					then
						vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
						vim.keymap.set("n", "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", {})
					else
						vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
					end
				end

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							lsp_formatting(bufnr)
							-- vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
