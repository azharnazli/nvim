return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  opts = {
    preview = {
      icon_provider = 'devicons', -- "mini" or "internal"
    },
    markdown = {
      block_quotes = { wrap = false },
      headings = { org_indent_wrap = false },
      list_items = { wrap = false },
    },
  },
}
