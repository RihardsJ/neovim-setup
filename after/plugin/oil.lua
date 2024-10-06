local status_ok, oil = pcall(require, "oil")
if not status_ok then
	return
end

-- Global function to retrieve the current directory
function _G.get_oil_winbar()
	local dir = require("oil").get_current_dir()
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

oil.setup({
	win_options = {
		winbar = "%!v:lua.get_oil_winbar()",
	},
})
