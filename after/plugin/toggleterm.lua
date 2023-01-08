local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	print("toggleterm plugin not found!")
	return
end

toggleterm.setup({
	autochdir = true,
})
