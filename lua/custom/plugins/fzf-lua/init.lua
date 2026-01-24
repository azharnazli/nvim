return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  opts = {
    keymap = {
      fzf = {
        ['alt-j'] = 'down',
        ['alt-k'] = 'up',
      },
    },
  },

  config = function(_, opts)
    local fzf = require 'fzf-lua'
    fzf.setup(opts)

    vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fw', fzf.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fg', fzf.grep_cword, { desc = 'Grep word' })
    vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Help tags' })
    vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Resume search' })
  end,
}
