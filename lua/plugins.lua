-- Automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Bootstrap packer
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- packer.nvim configuration
require("packer").init({
	profile = {
		enable = true,
	},
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Plugin List
require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- packer can manage itself
	use({ "nvim-lua/plenary.nvim", module = "plenary" }) -- load only when require
	use("kyazdani42/nvim-web-devicons")

	use("goolord/alpha-nvim")
	use({ "folke/which-key.nvim", requires = {
		"echasnovski/mini.nvim",
	} })
	use("navarasu/onedark.nvim")
	use({
		"nvim-lualine/lualine.nvim",
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			"cljoly/telescope-repo.nvim",
			"LinArcX/telescope-env.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-telescope/telescope-project.nvim",
		},
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("onsails/lspkind-nvim")

	use({
		"hrsh7th/nvim-cmp",
		wants = { "LuaSnip" },
		requires = {
			"L3MON4D3/LuaSnip",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"ray-x/cmp-treesitter",
			"saadparwaiz1/cmp_luasnip",
		},
	})
	use({
		"nvimtools/none-ls.nvim",
		requires = {
			"nvimtools/none-ls-extras.nvim",
			"gbprod/none-ls-shellcheck.nvim",
		},
	})
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})

	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
	use("theHamsta/nvim-dap-virtual-text")

	use({ "dinhhuy258/git.nvim" })
	use({ "lewis6991/gitsigns.nvim" })
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "shortcuts/no-neck-pain.nvim", tag = "*" })
	use({ "akinsho/toggleterm.nvim", tag = "v2.*" })
	use({ "stevearc/dressing.nvim" })
	use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "stevearc/oil.nvim" })

	use({ "kevinhwang91/nvim-ufo", requires = { "kevinhwang91/promise-async" } })
	use({ "luukvbaal/statuscol.nvim" })

	-- Avante setup
	use({
		"yetone/avante.nvim",
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- Optional dependencies
			"echasnovski/mini.nvim",
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			-- Image clip pasting
			{
				"HakonHarnes/img-clip.nvim",
				config = function()
					require("img-clip").setup({
						opts = {
							-- recommended settings
							default = {
								embed_image_as_base64 = false,
								prompt_for_file_name = false,
								drag_and_drop = {
									insert_mode = true,
								},
								-- required for Windows users
								use_absolute_path = true,
							},
						},
					})
				end,
			},
			-- -- Markdown setup for chat history
			{
				"MeanderingProgrammer/render-markdown.nvim",
				after = { "nvim-treesitter" },
				requires = {
					"echasnovski/mini.nvim",
					opt = true,
					config = function()
						require("render-markdown").setup({
							opts = {
								file_types = { "markdown", "Avante" },
							},
							ft = { "markdown", "Avante" },
						})
					end,
				},
			},
		},
	})
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
