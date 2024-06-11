local status_dap, dap = pcall(require, "dap")
if not status_dap then
	print("dap not found!")
	return
end

local status_dap_ui, dapui = pcall(require, "dapui")
if not status_dap_ui then
	print("dap not found!")
	return
end

-- / Logs path: ./config/cache/nvim/dap.log
dap.set_log_level("DEBUG")

-- == DAP UI == --
-- Setup virtual text
require("nvim-dap-virtual-text").setup({})
-- Automatically open and close the DAP UI when attaching or launching a debug session
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- == Signs == --
local set_sign = vim.fn.sign_define
set_sign("DapBreakpoint", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
set_sign("DapStopped", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
set_sign("DapBreakpointRejected", {
	text = "",
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

-- == Adapters == --
local DEBBUGER_LOCATION = {
	JAVASCRIPT = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
}

require("dap").adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { DEBBUGER_LOCATION.JAVASCRIPT, "${port}" },
	},
}
require("dap").adapters["pwa-chrome"] = {
	type = "executable",
	command = "node",
	args = { DEBBUGER_LOCATION.JAVASCRIPT },
}

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		-- Debug single node file
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
		-- Debug node preocess (make sure the node process is started with the `--inspect` flag)
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
		-- Debug client side JavaScript/Typescript in Chrome
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Launch & Debug Chrome",
			url = function()
				local co = coroutine.running()
				return coroutine.create(function()
					vim.ui.input({
						prompt = "Enter URL: ",
						default = "http://localhost:3000",
					}, function(url)
						if url == nil or url == "" then
							return
						else
							coroutine.resume(co, url)
						end
					end)
				end)
			end,
			webRoot = vim.fn.getcwd(),
			protocol = "inspector",
			sourceMaps = true,
			userDataDir = false,
		},
		-- Divider for the launch.json derived configs
		{
			name = "----- ↓ launch.json configs ↓ -----",
			type = "",
			request = "launch",
		},
	}
end
