local status_ok, avante = pcall(require, "avante")
if not status_ok then
	print("avante is not configured")
	return
end

require("avante_lib").load()
avante.setup({})
