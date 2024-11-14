return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline',
    },
    routes = {
      {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      },
    },
  },
}
