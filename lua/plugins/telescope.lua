return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function()
    local telescope = require("telescope")

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            height = 0.5,
            prompt_position = "top",
            preview_cutoff = 120,
            width = 0.7,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          ".cache",
          ".DS_Store",
        },
        prompt_prefix = "🔭 ",
        selection_caret = " ",
      },
      pickers = {},
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
  end,
}
