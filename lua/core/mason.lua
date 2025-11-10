return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',

  dependencies = {
    'whoissethdaniel/mason-tool-installer.nvim',
  },

  config = function()
    require('mason').setup()

    require('mason-tool-installer').setup {
      ensure_installed = {
        'lua-language-server',
        'vtsls',
        'json-lsp',
        'tailwindcss-language-server',
        'stylua',
        'prettierd',
      },
      run_on_start = true,
    }
  end,
}
