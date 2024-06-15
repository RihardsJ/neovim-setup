local status_dap, dap = pcall(require, "dap")
if not status_dap then
	print("dap not found!")
	return
end

-- == DAP UI == --
-- Setup virtual text to show in dap-ui
require("nvim-dap-virtual-text").setup({})

-- Automatically open dap ui when debugger is launched
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

-- == DAP CONFIGS == --
-- Set log level. Options: ["TRACE", "DEBUG", "INFO", "WARN", "ERROR"] (default "INFO")
dap.set_log_level("DEBUG") -- see logs with :DapShowLog

-- SIGNS --
local set_sign = vim.fn.sign_define
set_sign("DapBreakpoint", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
set_sign("DapStopped", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
set_sign("DapBreakpointRejected", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})

-- Keymaps --
local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "i", "v" }, "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F9>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F7>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F11>", "<Cmd>lua require'dap'.restart()<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<F12>", "<Cmd>lua require'dap'.close() require'dapui'.close()<CR>", opts)

-- == DAP server configurations == --
local PACKAGES_PATH = vim.fn.stdpath("data") .. "/mason/packages/"
local DEBUGGER_PATH = {
	JAVASCRIPT = PACKAGES_PATH .. "js-debug-adapter/js-debug/src/dapDebugServer.js",
}

print('DEBUGGER_PATH["JAVASCRIPT"]: ' .. DEBUGGER_PATH.JAVASCRIPT)
-- JavaScript
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { DEBUGGER_PATH.JAVASCRIPT, "${port}" },
	},
}

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			resolveSourceMapLocations = {
				"${workspaceFolder}/",
				"!/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Jest test file",
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			resolveSourceMapLocations = {
				"${workspaceFolder}/",
				"!/node_modules/**",
			},
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			name = "Attach - Remote Debugging",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			name = "Launch Chrome",
			request = "launch",
			url = "http://localhost:3000",
		},
	}
end
