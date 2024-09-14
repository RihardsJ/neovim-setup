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

local language_servers =
	{ "astro", "bashls", "eslint", "cssls", "html", "jsonls", "quick_lint_js", "pyright", "lua_ls", "ts_ls" }

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
	local configs = {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	if server == "lua_ls" then
		configs.settings = {
			Lua = {
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "require" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
			},
		}
	elseif server == "tsserver" then
		configs.root_dir = lsp.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
	elseif server == "eslint" then
		configs.root_dir = lsp.util.root_pattern(
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json"
		)
	end
	lsp[server].setup(configs)
end

-- Diagnosymbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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
		source = true,
		header = "",
		prefix = "",
	},
})
