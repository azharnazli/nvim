require('lazy').setup({
  'tpope/vim-sleuth',
  require 'core/which-key',
  require 'core/mason',
  require 'core/lspconfig',
  require 'core/cmp',
  require 'core/treesitter',
  require 'core/trouble',
  require 'core/conform',
  require 'core/autopair',
  require 'core/gitsigns',
  require 'core/indent-line',
  require 'core/debug',
  require 'core.todo_comments',

  { import = 'custom/plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    local nt_ok, nt_manager = pcall(require, 'neo-tree.sources.manager')
    if nt_ok then
      nt_manager.refresh 'filesystem'
    end

    local gs_ok, gitsigns = pcall(require, 'gitsigns')
    if gs_ok then
      gitsigns.refresh()
    end
  end,
})
