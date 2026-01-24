require('lazy').setup({
  'tpope/vim-sleuth',
  require 'core/which-key',
  require 'core/mason',
  require 'core/lspconfig',
  require 'core/cmp',
  require 'core/treesitter',
  require 'core/neotree',
  require 'core/conform',
  require 'core/autopair',
  require 'core/gitsigns',
  require 'core/indent-line',
  require 'core/debug',

  { import = 'custom/plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
    local status_ok, manager = pcall(require, 'neo-tree.sources.manager')
    if status_ok then
      manager.refresh 'filesystem'
    end
  end,
})
