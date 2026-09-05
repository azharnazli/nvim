return {
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html',
    keys = {
      { '<leader>Lm', '<cmd>Leet<CR>', desc = 'LeetCode Menu' },
      { '<leader>Lr', '<cmd>Leet run<CR>', desc = 'LeetCode Run' },
      { '<leader>Ls', '<cmd>Leet submit<CR>', desc = 'LeetCode Submit' },
      { '<leader>Li', '<cmd>Leet info<CR>', desc = 'LeetCode Info' },
    },
    opts = {
      lang = 'javascript',
    },
  },
}
