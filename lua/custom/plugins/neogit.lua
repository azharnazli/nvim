return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    -- 'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed.
    'ibhagwan/fzf-lua', -- optional
    'echasnovski/mini.pick', -- optional
  },
  init = function()
    local neogit = require 'neogit'
    neogit.setup {}
    vim.keymap.set(
      'n',
      '<leader>gn',
      '<cmd>Neogit<cr>',
      { desc = 'Open Neogit' }
    )
  end,
}
