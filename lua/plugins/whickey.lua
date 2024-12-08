local keymaps = {
  {
    "<leader>?",
    function()
      require("which-key").show({ global = false })
    end,
    desc = "Buffer Keymaps",
  },
  { "<leader>w",  "<cmd>w<cr>",                                      desc = "Write" },
  { "<leader>q",  "<cmd>q<cr>",                                      desc = "Quit" },
  { "<leader>c",  "<Cmd>BufferClose<CR>",                            desc = "Close" },
  { "<leader>C",  "<Cmd>BufferCloseAllButCurrent<CR>",               desc = "Close Others" },
  -- Buffer
  { "<leader>b",  group = "Buffer" },
  { "<leader>bl", "<Cmd>Telescope buffers<CR>",                      desc = "List" },
  { "<leader>bn", "<Cmd>enew<CR>",                                   desc = "New" },
  { "<leader>bh", "<Cmd>split<CR><C-w>w<CR>:b#<CR><C-w>p<CR>",       desc = "Split horizontaly" },
  { "<leader>bv", "<Cmd>vsplit<CR><C-w>w<CR>:b#<CR><C-w>p<CR>",      desc = "Split verticaly" },
  { "<leader>br", "<Cmd>BufferRestore<CR>",                          desc = "Restore" },
  -- Buffer navigation
  { "<A-,>",      "<Cmd>BufferPrevious<CR>" },
  { "<A-.>",      "<Cmd>BufferNext<CR>" },
  { "<A-<>",      "<Cmd>BufferMovePrevious<CR>" },
  { "<A->>",      "<Cmd>BufferMoveNext<CR>" },
  -- Git
  { "<leader>g",  group = "Git",                                     desc = "Git" },
  { "<leader>gd", "<CMD>lua ToggleDiffView()<CR>",                   desc = "Diff" },
  { "<leader>gl", "<CMD>DiffviewLog<CR>",                            desc = "Log" },
  { "<leader>gh", "<CMD>DiffviewFileHistory<CR>",                    desc = "History" },
  { "<leader>gf", "<CMD>DiffviewFileHistory %<CR>",                  desc = "Curent file history" },
  -- Todo Comments
  { "]t",         "<CMD>lua require'todo-comments'.jump_next()<CR>", desc = "Next todo comment" },
  { "[t",         "<CMD>lua require'todo-comments'.jump_prev()<CR>", desc = "Previous todo comment" },
}

function ToggleDiffView()
  if next(require("diffview.lib").views) == nil then
    -- Open diff view if it's not open
    vim.cmd("DiffviewOpen")
  else
    -- Close diff view if it's already open
    vim.cmd("DiffviewClose")
  end
end

function BufferDelete()
  local current_buffer = vim.api.nvim_get_current_buf()

  if vim.api.nvim_get_option_value("modified", { buf = current_buffer }) then
    local choice = vim.fn.confirm("Buffer is modified. Save changes?", "&Yes\n&No\n&Cancel", 1)

    if choice == 1 then
      vim.cmd("write")
    elseif choice == 3 then
      return
    end

    vim.cmd("bdelete!")
  else
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local total_nr_buffers = #buffers

    if total_nr_buffers == 1 then
      vim.cmd("bdelete")
      vim.cmd("enew") -- Create a new empty buffer if no other listed buffer exists
    else
      vim.cmd("bprevious")
      vim.cmd("bdelete #")
    end
  end
end

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = keymaps,
}
