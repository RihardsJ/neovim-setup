function custom_nertw_toggle()
    if  vim.api.nvim_buf_get_option(0, 'filetype') == 'netrw' then
      local buffers_list = vim.api.nvim_exec(':ls<CR>', false)
      if (#buffers_list == 0) then
        vim.api.nvim_exec(':bd', false)
      else
        vim.api.nvim_exec(':bp', false)
      end
    else
      vim.api.nvim_exec(':Explore', false) 
    end
 end

 return custom_nertw_toggle 
