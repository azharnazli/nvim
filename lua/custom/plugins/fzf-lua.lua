return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    files = {
      fd_opts = '--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude build --exclude .cache --exclude dist --exclude target --exclude .next --exclude .turbo --exclude .env --exclude .env.local',
    },
    winopts = {
      fullscreen = true,
    },
    keymap = {
      fzf = {
        ['alt-j'] = 'down',
        ['alt-k'] = 'up',
      },
    },
  },
  keys = {
    {
      '<leader>ff',
      '<cmd>lua require("fzf-lua").files()<cr>',
      desc = 'Find files',
    },
    -- Toggle hidden/ignored files with dot
    {
      '<leader>fF',
      function()
        require('fzf-lua').files {
          prompt = 'Files (all)❯ ',
          fd_opts = '--color=never --type f --hidden --follow --no-ignore',
        }
      end,
      desc = 'Find files (all)',
    },
    {
      '<leader>fw',
      '<cmd>lua require("fzf-lua").live_grep()<cr>',
      desc = 'Live grep',
    },
    {
      '<leader>fg',
      '<cmd>lua require("fzf-lua").grep_cword()<cr>',
      desc = 'Grep word',
    },
    {
      '<leader>fo',
      '<cmd>lua require("fzf-lua").oldfiles()<cr>',
      desc = 'Recent files',
    },
    {
      '<leader>fb',
      '<cmd>lua require("fzf-lua").buffers()<cr>',
      desc = 'Buffers',
    },
    {
      '<leader>fh',
      '<cmd>lua require("fzf-lua").helptags()<cr>',
      desc = 'Help tags',
    },
    {
      '<leader>fk',
      '<cmd>lua require("fzf-lua").keymaps()<cr>',
      desc = 'Keymaps',
    },
    {
      '<leader>fr',
      '<cmd>lua require("fzf-lua").resume()<cr>',
      desc = 'Resume search',
    },
  },
  config = function(_, opts)
    require('fzf-lua').setup(opts)
  end,
}
