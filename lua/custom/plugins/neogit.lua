return {
  'NeogitOrg/neogit',
  cmd = {
    'Neogit',
  },
  keys = {
    {
      '<leader>gn',
      '<cmd>Neogit<cr>',
      desc = 'Open Neogit',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    -- 'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'ibhagwan/fzf-lua', -- optional
    'echasnovski/mini.pick', -- optional
  },
  opts = {},
  config = function(_, opts)
    require('neogit').setup(opts)
  end,
}
