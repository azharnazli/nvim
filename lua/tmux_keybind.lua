-- lua/tmux-keymap.lua

vim.keymap.set('n', '<leader>nl', function()
  vim.fn.jobstart { 'tmux', 'split-window', '-h', '-p', '20' }
end, { desc = 'tmux: right 20%' })

vim.keymap.set('n', '<leader>nf', function()
  vim.fn.jobstart { 'tmux', 'split-window', '-h', '-p', '50' }
end, { desc = 'tmux: right 50%' })

vim.keymap.set('n', '<leader>nh', function()
  vim.fn.jobstart { 'tmux', 'split-window', '-h', '-p', '20' }
  vim.fn.jobstart { 'tmux', 'swap-pane', '-s', '{last}', '-t', '{left-of}' }
end, { desc = 'tmux: left 20%' })

vim.keymap.set('n', '<leader>nb', function()
  vim.fn.jobstart { 'tmux', 'split-window', '-v', '-p', '20' }
end, { desc = 'tmux: bottom 20%' })
