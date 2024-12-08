return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "warmer",
      code_style = {
        comments = "italic",
        keywords = "italic",
        functions = "none",
        strings = "none",
        variables = "none",
      }
    },
    config = function()
        require('onedark').load()
    end
}
