local indent = 2

local options = {
	cursorline = true,
	number = true,
	relativenumber = true,
	signcolumn = "yes", -- dedicate space for LSP diagnostic, breakpoints etc. (default: auto)
	showtabline = 2,
	termguicolors = true,
	title = true,

	scrolloff = 12,
	sidescrolloff = 120, -- cursor is placed in the middle, works only when wrap is off
	smartindent = true,
	expandtab = true,
	wrap = false,
	shiftwidth = indent,
	tabstop = indent,
	softtabstop = indent,

	clipboard = "unnamedplus",

	cdhome = true, -- changed working directory to $HOME if not arguments supplied

	ignorecase = true,
	smartcase = true,

	splitbelow = true,
	splitright = true,

	timeoutlen = 250,

	spell = false, -- enable spell checking
	spelllang = "en_gb",
	spellsuggest = "best,9",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
