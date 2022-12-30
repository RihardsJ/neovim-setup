local status_ok, onedark = pcall(require, 'onedark')
if not status_ok then 
  print('onedark not found!') 
  return 
end

onedark.setup {
  style = 'warm',
  code_style = {
    comments = 'italic',
    keywords = 'italic',
    functions = 'none',
    strings = 'none',
    variables = 'none',
  },
}

onedark.load()
