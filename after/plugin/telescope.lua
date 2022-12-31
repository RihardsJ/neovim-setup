local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  print('telescope not found!')
  return
end

-- == Extensions == --

-- == Setup == --
-- local actions = require"telescope.actions"

telescope.setup {}

require'telescope'.load_extension('project')
require'telescope'.load_extension('env')
require'telescope'.load_extension('repo')
require('telescope').load_extension('fzf')

