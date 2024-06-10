local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	print("null_ls not found!")
	return
end

-- == Auto formatting == --
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- == Setup == --
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion

null_ls.setup({
	debug = true,
	sources = {
		formatting.stylua,
		formatting.prettierd.with({
			disabled_filetypes = {
				"markdown",
				"md",
			},
		}),
		require("none-ls.formatting.eslint_d").with({
			disabled_filetypes = {
				"markdown",
				"md",
			},
		}),
		formatting.stylua,
		require("none-ls.diagnostics.eslint_d").with({
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
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
