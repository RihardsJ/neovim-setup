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
	sources = {
		formatting.prettierd,
		formatting.fixjson,
		formatting.stylua,
		diagnostics.eslint_d.with({
			diagnostics_format = "[eslint] #{m}\n(#{c})",
			only_local = "node_modules/.bin",
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- vim.lsp.buf.format({ bufnr = bufnr })
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
