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
        -- LSP servers (Mason package names)
        'lua-language-server',
        'vtsls',
        'json-lsp',
        'tailwindcss-language-server',

        -- Tools
        'prettier',
        'stylua',
        -- add more tools here if you like
      },
      run_on_start = false, -- install only when you manually call :MasonToolsInstall
    }
  end,
}
