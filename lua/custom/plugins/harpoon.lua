return {
  'ThePrimeagen/harpoon',
  opts = {},
  config = function()
    vim.keymap.set('n', '<c-e>', ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
    vim.keymap.set('n', '<c-o>', ":lua require('harpoon.mark').add_file()<cr>")
    vim.keymap.set('n', '<c-n>', ":lua require('harpoon.ui').nav_next()<cr>")
    vim.keymap.set('n', '<c-N>', ":lua require('harpoon.ui').nav_prev()<cr>")
  end,
}
