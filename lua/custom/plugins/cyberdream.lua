return {
  'scottmckendry/cyberdream.nvim',
  init = function()
    vim.cmd.colorscheme 'cyberdream'
  end,
  tags = 'v5.2.0',
  opts = {
    transparent = true,
    italic_comments = false,
    terminal_colors = true,
    variant = 'default', -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
  },
}
