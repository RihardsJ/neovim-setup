local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  print('lualine not found!')
  return
end

lualine.setup {
  options = {
    theme = 'onedark'
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'windows'},
    lualine_z = {'tabs'}
  },
    sections = {
      lualine_c = {
        {
          'filename',
          path = 1, -- (0: Just the filename 1: Relative path 2: Absolute path 3: Absolute path, with tilde as the home directory 4: Filename and parent dir, with tilde as the home directory)
        }
      }
}}
