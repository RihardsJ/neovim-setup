-- == Mason == --
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	print("mason not found!")
	return
end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- == Mason LSP == --
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
	print("mason lsp config not found!")
	return
end

local language_servers = { "bashls", "cssls", "eslint", "html", "jsonls", "pyright", "sumneko_lua", "tsserver" }

mason_lsp.setup({
	ensure_installed = language_servers,
	automatic_installation = true,
})

-- == LSP config == --
local lsp_ok, lsp = pcall(require, "lspconfig")
if not lsp_ok then
	print("lspconfig not found!")
	return
end

local on_attach = function(client, buffer)
	local bufopts = { noremap = true, silent = true, buffer = buffer }

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in pairs(language_servers) do
	if server == "sumneko_lua" then
		lsp[server].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			},
		})
	else
		lsp[server].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end
end

-- Diagnosymbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		severity = { min = vim.diagnostic.severity.WARN },
	},
	sevirity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})
