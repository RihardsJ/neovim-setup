local status_ok, statuscol = pcall(require, "statuscol")
if not status_ok then
	print("statuscol not found!")
	return
end

local builtin = require("statuscol.builtin")

statuscol.setup({
	segments = {
		{ text = { "%s" }, click = "v:lua.ScSa" },
		{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
		{
			text = { " ", builtin.foldfunc, " " },
			condition = { builtin.not_empty, true, builtin.not_empty },
			click = "v:lua.ScFa",
		},
	},
})
