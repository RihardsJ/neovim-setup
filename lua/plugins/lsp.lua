local language_servers = {
	"lua_ls",
	"ts_ls",
	"eslint",
	"html",
	"cssls",
	"jsonls",
	"yamlls",
	"tailwindcss",
	"pyright",
	"rust_analyzer",
}

local on_attach = function(client, buffer)
	local bufopts = { noremap = true, silent = true, buffer = buffer }

	-- Mappings
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gR", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)

	-- Show diagnostics on hover
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = buffer,
		callback = function()
			local float_opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always",
				prefix = " ",
				scope = "cursor",
			}
			vim.diagnostic.open_float(nil, float_opts)
		end,
	})
end

local lua_ls = {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
			hint = {
				enable = true,
				arrayIndex = "Enable",
				setType = true,
				paramName = "All",
				paramType = true,
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
}

return {
	-- Mason
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	-- Mason LSP configs
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = language_servers,
			automatic_installation = true,
		},
	},
	-- LSP configs
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/neodev.nvim", opts = {} },
			{
				"kosayoda/nvim-lightbulb",
				opts = {
					autocmd = { enabled = true },
					ignore = { clients = { "null-ls" } },
					sign = { enabled = true, text = "" },
				},
			},
			{
				"ray-x/lsp_signature.nvim",
				opts = {
					bind = true,
					handler_opts = { border = "rounded" },
					hint_enable = false, -- We use inlay hints instead
					floating_window = true,
					toggle_key = "<C-k>", -- Toggle signature
					select_signature_key = "<C-n>", -- Toggle between signatures
				},
			},
		},
		config = function()
			-- Setup neodev first
			require("neodev").setup()

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Enable autoformat
			capabilities.documentFormattingProvider = true
			capabilities.documentRangeFormattingProvider = true

			for _, server in ipairs(language_servers) do
				local configs = {
					on_attach = on_attach,
					capabilities = capabilities,
					flags = {
						debounce_text_changes = 150,
					},
				}

				if server == "lua_ls" then
					configs.settings = lua_ls.settings
				elseif server == "ts_ls" then
					configs.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
					configs.single_file_support = true
				elseif server == "eslint" then
					configs.root_dir = lspconfig.util.root_pattern(
						".eslintrc",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.yaml",
						".eslintrc.yml",
						".eslintrc.json"
					)
				end

				lspconfig[server].setup(configs)
			end

			-- Diagnostic signs
			local signs = {
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Diagnostic config
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					prefix = "●",
					spacing = 4,
					source = "if_many",
					severity = { min = vim.diagnostic.severity.WARN },
				},
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = "if_many",
					header = "",
					prefix = "",
				},
			})

			-- Better UI for hover and signature help
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
		end,
	},
}
