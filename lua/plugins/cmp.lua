local cmp_configs = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local luasnip = require("luasnip")
	local cmp_map = cmp.mapping

	vim.cmd([[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]])

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp_map.preset.insert({
			["<Tab>"] = cmp_map(cmp_map.select_next_item()),
			["<S-Tab>"] = cmp_map(cmp_map.select_prev_item()),
			["<C-b>"] = cmp_map.scroll_docs(-4),
			["<C-f>"] = cmp_map.scroll_docs(4),
			["<C-Space>"] = cmp_map.complete(),
			["<C-e>"] = cmp_map.abort(),
			["<CR>"] = cmp_map({
				i = function(fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					else
						fallback()
					end
				end,
				s = cmp_map.confirm({ select = true }),
				c = cmp_map.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			}),
		}),
		sources = cmp.config.sources({
			{ name = "buffer" },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "cmdline" },
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			{ name = "path" },
			{ name = "treesitter" },
			{ name = "html-css" },
			{ name = "css-variables" },
			{ name = "fonts", option = { space_filter = "-" } },
			-- { name = 'npm', keyword_length = 4 },
			{ name = "nvim_lsp_signature_help" },
		}),

		formatting = {
			format = lspkind.cmp_format({
				with_text = false,
				maxwidth = 50,
				before = function(entry, vim_item)
					if entry.source.name == "html-css" then
						vim_item.menu = entry.completion_item.menu
					end
					return vim_item
				end,
			}),
		},
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp_map.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline({ ":" }, {
		mapping = cmp_map.preset.cmdline(),
		sources = {
			{ name = "path" },
			{ name = "cmdline" },
		},
	})

	-- Add parentheses after selecting function or method item
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return {
	"hrsh7th/nvim-cmp",

	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-calc",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
		"amarakon/nvim-cmp-fonts",
		"roginfarrer/cmp-css-variables",
		"Jezda1337/nvim-html-css",
		"ray-x/cmp-treesitter",
	},

	event = { "InsertEnter", "CmdlineEnter" },
	config = cmp_configs,
	-- {
	--   "David-Kunz/cmp-npm",
	--   dependencies = { 'nvim-lua/plenary.nvim' },
	--   ft = "json",
	--   config = function()
	--     require('cmp-npm').setup({})
	--   end
	-- }
}
