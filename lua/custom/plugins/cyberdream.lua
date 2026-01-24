return {
  'scottmckendry/cyberdream.nvim',
  init = function()
    vim.cmd.colorscheme 'cyberdream'
  end,
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      bg = '#000000',
    },
  },
}
