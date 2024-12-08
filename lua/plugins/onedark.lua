return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "warmer",
    },
    config = function()
        require('onedark').load()
    end
}
