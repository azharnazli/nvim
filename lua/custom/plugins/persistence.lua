return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- start tracking as soon as a file is read
  opts = {
    -- you can leave this empty to use defaults
    -- dir = vim.fn.stdpath("state") .. "/sessions/",
    -- options = { "buffers", "curdir", "tabpages", "winsize" },
  },
  keys = {
    {
      '<leader>Ps',
      function()
        require('persistence').load()
      end,
      desc = 'Persistence: load session',
    },
    {
      '<leader>PS',
      function()
        require('persistence').select()
      end,
      desc = 'Persistence: select session',
    },
    {
      '<leader>Pl',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Persistence: load last session',
    },
    {
      '<leader>Pd',
      function()
        require('persistence').stop()
      end,
      desc = 'Persistence: stop saving',
    },
  },
}
