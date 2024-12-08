return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "c",
        "cpp",
        "yaml",
        "diff",
        "gitignore",
        "dockerfile",
        "graphql",
        "lua",
        "vim",
        "yaml",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "html",
        "scss",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
      rainbow = {
        enable = true,
        extended_mode = true,
      },
    })
  end,
}
