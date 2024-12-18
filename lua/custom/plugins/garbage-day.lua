return {
  'zeioth/garbage-day.nvim',
  dependencies = 'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  opts = {
    grace_period = 60 * 10,
    notifications = true,
    aggresive_mode = true,
  },
}
