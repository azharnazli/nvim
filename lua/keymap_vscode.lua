vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-s>', '<cmd>:w<cr>', { desc = 'Save current file' })
vim.keymap.set('v', '<C-d>', '<C-d>zz')
vim.keymap.set('v', '<C-u>', '<C-u>zz')

vim.keymap.set('n', '<Space>e', function()
  vim.fn['VSCodeNotify'] 'workbench.view.explorer'
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>c', function()
  vim.fn['VSCodeNotify'] 'workbench.action.closeActiveEditor'
end, { noremap = true, silent = true })

vim.keymap.set(
  'n',
  '<leader>lr',
  vim.lsp.buf.rename,
  { noremap = true, silent = true }
)

vim.keymap.set('n', '<leader>fw', function()
  vim.fn['VSCodeNotify'] 'periscope.search'
end, { noremap = true, silent = true })
