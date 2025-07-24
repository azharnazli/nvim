return {
  'r0nsha/qfpreview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    ui = {
      height = 'fill',
      show_name = true,
      win = {},
    },
    opts = {
      throttle = 100,
      lsp = true,
      diagnostics = true,
    },
  },
}
