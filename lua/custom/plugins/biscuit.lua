return {
  'code-biscuits/nvim-biscuits',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    cursor_line_only = true,
    default_config = {
      max_length = 12,
      min_distance = 5,
    },
  },
}
