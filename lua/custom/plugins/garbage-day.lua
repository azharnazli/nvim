return {
  'zeioth/garbage-day.nvim',
  dependencies = 'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  opts = {
    aggressive_mode = false, -- If true, it stops LSPs when you simply switch buffers.
    grace_period = 60 * 5, -- Time in seconds (e.g., 15 minutes) before stopping an inactive LSP.
    wakeup_delay = 0, -- How fast to restart (0 is instant).
    notifications = true, -- Show a message when an LSP is stopped/started.
  },
}
