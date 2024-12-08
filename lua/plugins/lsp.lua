local language_servers = {
  "lua_ls",
  "ts_ls",
  "eslint",
}

local on_attach = function(_, buffer)
  local bufopts = { noremap = true, silent = true, buffer = buffer }
  vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "gR", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
end

local lua_ls = {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "require" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
}

return {
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  -- Mason LSP configs
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = language_servers,
      automatic_installation = true,
      handlers = nil,
    },
  },
  -- LSP configs
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for _, server in ipairs(language_servers) do
        local configs = {
          on_attach = on_attach,
          capabilities = capabilities,
        }

        if server == "lua_ls" then
          configs.settings = lua_ls.settings
        elseif server == "ts_ls" then
          configs.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
        elseif server == "eslint" then
          configs.root_dir = lspconfig.util.root_pattern(
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json"
          )
        end

        lspconfig[server].setup(configs)
      end

      -- Diagnosymbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          severity = { min = vim.diagnostic.severity.WARN },
        },
        sevirity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })
    end,
  },
}
