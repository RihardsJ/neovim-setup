local status_ok, avante = pcall(require, "avante")
if not status_ok then
	print("avante is not configured")
	return
end

require("avante_lib").load()
avante.setup({
	provider = "copilot",
	auto_suggestions_provider = "copilot",
	behaviour = {
		auto_suggestions = true, -- Experimental feature
	},
	mappings = {
		suggestion = {
			accept = "<C-j>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
})
