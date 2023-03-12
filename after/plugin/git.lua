local status_ok, git = pcall(require, "git")
if not status_ok then
	print("git plugin not found!")
end

git.setup()
