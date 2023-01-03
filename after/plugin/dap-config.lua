local status_dap, dap = pcall(require, "dap")
if not status_dap then
	print("dap not found!")
	return
end

-- / Logs path: ./config/cache/nvim/dap.log
dap.set_log_level("DEBUG")

require("nvim-dap-virtual-text").setup({})

-- == Listeners == --
local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- == Signs == --
local set_sign = vim.fn.sign_define
set_sign("DapBreakpoint", {
	text = "🔴",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
set_sign("DapStopped", {
	text = "🟢",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
set_sign("DapBreakpointRejected", {
	text = "⚪",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})

-- == Keymaps == --
local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "i", "v" }, "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F6>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F7>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F9>", "<Cmd>lua require'dap'.restart()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F12>", "<Cmd>lua require'dap'.close() require'dapui'.close()<CR>", opts)

-- == DAP server configurations == --
require("dap-python").setup("~/.config/local/share/nvim/mason/packages/debugpy/venv/bin/python")
