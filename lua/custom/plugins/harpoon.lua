return {
  'ThePrimeagen/harpoon',
  opts = {},
  config = function()
    vim.keymap.set(
      'n',
      '<c-e>',
      ':Telescope harpoon marks<cr>',
      { silent = true }
    )
    vim.keymap.set(
      'n',
      "<c-'>",
      ":lua require('harpoon.mark').add_file()<cr>",
      { silent = true }
    )
    vim.keymap.set(
      'n',
      '<c-n>',
      ":lua require('harpoon.ui').nav_next()<cr>",
      { silent = true }
    )
    vim.keymap.set(
      'n',
      '<c-N>',
      ":lua require('harpoon.ui').nav_prev()<cr>",
      { silent = true }
    )
  end,
}
