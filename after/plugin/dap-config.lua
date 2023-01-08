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
-- Python
require("dap-python").setup("~/.config/local/share/nvim/mason/packages/debugpy/venv/bin/python")
-- JavaScript
require("dap-vscode-js").setup({
	node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "javascript" }) do
	require("dap").configurations[language] = {
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
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
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
	}
end

for _, language in ipairs({ "typescriptreact", "javascriptreact" }) do
	require("dap").configurations[language] = {
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
