return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'b0o/schemastore.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'dmmulroy/ts-error-translator.nvim',
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
      },
    },
  },

  opts = {
    servers = {
      vtsls = {}, -- TS/JS (fast & nice)
      lua_ls = {
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
      },
      tailwindcss = {},
      eslint = {},
    },
  },

  config = function(_, opts)
    -- mason
    require('mason').setup()
    require('mason-tool-installer').setup {
      ensure_installed = {
        'jsonls',
        'vtsls',
        'lua-language-server',
        'tailwindcss-language-server',
        'eslint-lsp',
        'prettierd',
        'stylua',
      },
    }

    local function on_attach(_, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map('n', 'gd', vim.lsp.buf.definition, 'LSP: goto def')
      map('n', 'gr', vim.lsp.buf.references, 'LSP: refs')
      map('n', 'gI', vim.lsp.buf.implementation, 'LSP: impl')
      map('n', 'gy', vim.lsp.buf.type_definition, 'LSP: type def')
      map('n', '<leader>lr', vim.lsp.buf.rename, 'LSP: rename')
      map({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, 'LSP: action')
      map('n', 'K', vim.lsp.buf.hover, 'LSP: hover')
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local lspconfig = require 'lspconfig'

    local schemastore_ok, schemastore = pcall(require, 'schemastore')
    lspconfig.jsonls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        json = {
          schemas = schemastore_ok and schemastore.json.schemas() or {},
          validate = { enable = true },
        },
      },
    }

    for name, conf in pairs(opts.servers or {}) do
      conf.on_attach = on_attach
      conf.capabilities =
        vim.tbl_deep_extend('force', capabilities, conf.capabilities or {})
      lspconfig[name].setup(conf)
    end
  end,
}
