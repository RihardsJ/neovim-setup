local status_cmp, cmp = pcall(require, "cmp")
local status_lspkind, lspkind = pcall(require, "lspkind")

if not status_cmp then
  print('cmp not found!')
  return
end

if not status_lspkind then
  print('lspkind not found!')
  return
end

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]

cmp.setup {
  snippet = {
    expand = function(args) 
      require("luasnip").lsp_expand(args.body)
    end,
  }, 
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'path' },
      { name = 'spell' },
      { name = 'treesitter' },
    }),

  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  }
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline({ ':' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  } 
})
