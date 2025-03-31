local cmp_configs = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local luasnip = require("luasnip")
	local cmp_map = cmp.mapping

	-- Load friendly-snippets
	require("luasnip.loaders.from_vscode").lazy_load()

	vim.cmd([[
    set completeopt=menu,menuone,noselect
    highlight PmenuSel guibg=#4C566A guifg=#ECEFF4 gui=bold
    highlight Pmenu guibg=#2E3440 guifg=#D8DEE9
    highlight PmenuBorder guifg=#3B4252
    highlight CmpItemAbbrMatch guibg=NONE guifg=#88C0D0 gui=bold
    highlight CmpItemAbbrMatchFuzzy guibg=NONE guifg=#88C0D0 gui=bold
  ]])

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		window = {
			completion = {
				winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:PmenuBorder,Search:None",
				scrollbar = true,
				col_offset = -3,
				side_padding = 1,
				border = "rounded",
			},
			documentation = {
				winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,Search:None",
				max_width = 80,
				max_height = 12,
				border = "rounded",
			},
		},
		mapping = cmp_map.preset.insert({
			["<Tab>"] = cmp_map(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp_map(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
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
			{ name = "nvim_lsp", priority = 1000 },
			{ name = "luasnip", priority = 750 },
			{ name = "buffer", priority = 500 },
			{ name = "path", priority = 250 },
			{ name = "git" },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "cmdline" },
			{ name = "treesitter" },
			{ name = "html-css" },
			{ name = "css-variables" },
			{ name = "fonts", option = { space_filter = "-" } },
			{ name = "nvim_lsp_signature_help" },
		}),
		sorting = {
			priority_weight = 2,
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.locality,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			expandable_indicator = true,
			format = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 80,
				menu = {
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					luasnip = "[Snippet]",
					path = "[Path]",
					calc = "[Calc]",
				},
				ellipsis_char = "...",
				before = function(entry, vim_item)
					if entry.source.name == "html-css" then
						vim_item.menu = entry.completion_item.menu
					end
					vim_item.menu = vim_item.menu or string.format("[%s]", entry.source.name)
					return vim_item
				end,
			}),
		},
	})

	-- `/` cmdline setup.
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp_map.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- `:` cmdline setup.
	cmp.setup.cmdline(":", {
		completion = {
			autocomplete = false,
		},
		mapping = cmp_map.preset.cmdline({
			["<C-Space>"] = cmp_map.complete(),
			["<Tab>"] = cmp_map(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end),
			["<S-Tab>"] = cmp_map(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end),
		}),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})

	-- Set up git source
	require("cmp_git").setup()

	-- Add parentheses after selecting function or method item
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return {
	"hrsh7th/nvim-cmp",

	dependencies = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
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
		"petertriho/cmp-git",
		"hrsh7th/cmp-emoji",
	},

	event = { "InsertEnter", "CmdlineEnter" },
	config = cmp_configs,
}
