return {
  'neovim/nvim-lspconfig',
  dependencies = {
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
}
