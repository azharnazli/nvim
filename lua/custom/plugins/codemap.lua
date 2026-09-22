return {
  'm2k3d/codemap',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cmd = { 'CodemapOpen', 'CodemapToggle', 'CodemapClose' },
  event = 'VeryLazy', -- load shortly after startup, so auto_open kicks in
  config = function(_, opts)
    require('codemap').setup(opts)

    local function set_highlights()
      vim.api.nvim_set_hl(0, 'CodemapFunction', { fg = '#7aa2f7' })
      vim.api.nvim_set_hl(0, 'CodemapMethod', { fg = '#bb9af7' })
      vim.api.nvim_set_hl(0, 'CodemapClass', { fg = '#e0af68' })
      vim.api.nvim_set_hl(0, 'CodemapStruct', { fg = '#9ece6a' })
    end

    set_highlights()

    local group =
      vim.api.nvim_create_augroup('UserCodemapHighlights', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = group,
      callback = set_highlights,
    })
  end,
  opts = {
    width = 30, -- sidebar width, columns
    update_events = { 'BufEnter', 'TextChanged', 'TextChangedI' }, -- when to refresh the list
    debounce_ms = 300, -- delay before re-parsing after a text edit
    auto_open = false, -- open the sidebar automatically on startup (default: false)
  },
}
