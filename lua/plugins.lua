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
  require 'core/todo_comments',

  { import = 'custom/plugins' },
}, {
  change_detection = {
    notify = false,
  },
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

local focus_refresh_group = vim.api.nvim_create_augroup(
  'user-focus-refresh',
  { clear = true }
)
local last_focus_refresh = 0

vim.api.nvim_create_autocmd('FocusGained', {
  group = focus_refresh_group,
  callback = function()
    local now = vim.uv.now()
    if now - last_focus_refresh < 1500 then
      return
    end
    last_focus_refresh = now

    if package.loaded['neo-tree.sources.manager'] then
      local nt_ok, nt_manager = pcall(require, 'neo-tree.sources.manager')
      if nt_ok then
        nt_manager.refresh 'filesystem'
      end
    end

    if package.loaded.gitsigns then
      local gs_ok, gitsigns = pcall(require, 'gitsigns')
      if gs_ok then
        gitsigns.refresh()
      end
    end
  end,
})

require 'core.tmux'
