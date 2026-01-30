require 'tmux_keybind'
local keymap_helper = require 'keymaps_helper'

vim.keymap.set(
  'n',
  '<leader>pr',
  keymap_helper.run_project,
  { desc = 'Project: Run Project' }
)

vim.keymap.set(
  'n',
  '<leader>pR',
  keymap_helper.tmux_pane_right,
  { desc = 'Project: Run in tmux right 35%' }
)

vim.keymap.set(
  'n',
  '<leader>tb',
  ':tabedit %<cr>',
  { desc = 'Tab: Promote current buffer to new tab' }
)
vim.keymap.set('n', '<leader>td', ':tabc<cr>', { desc = 'Tab: close tab' })
vim.keymap.set(
  'n',
  '<leader>tD',
  ':tabo<cr>',
  { desc = 'Tab: close all tab except this' }
)
vim.keymap.set('n', '<leader>tn', ':tabn<cr>', { desc = 'Tab: move next tab' })
vim.keymap.set(
  'n',
  '<leader>tp',
  ':tabp<cr>',
  { desc = 'Tab: move previous tab' }
)

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: goto def' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: refs' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'LSP: impl' })
vim.keymap.set(
  'n',
  'gy',
  vim.lsp.buf.type_definition,
  { desc = 'LSP: type def' }
)
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'LSP: rename' })
vim.keymap.set({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, {
  desc = 'LSP: action',
})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: hover' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set(
  'n',
  '<c-q>',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic Quickfix list' }
)

vim.keymap.set('n', '<leader>bd', function()
  require('mini.bufremove').delete()
end, { desc = 'Close Current Buffer' })

vim.keymap.set(
  'n',
  '<leader>bD',
  function() end,
  { desc = 'Close all buffers except current' }
)

vim.keymap.set('n', '<leader>bl', function()
  vim.cmd('e ' .. vim.g.last_path)
end, { desc = 'Resume last close buffer' })

vim.keymap.set('n', '<leader>nr', function()
  keymap_helper.reload_config()
  print 'Config Reloaded!!'
end, { desc = 'NEOVIM: reload neovim config' })

vim.keymap.set('n', '<C-s>', '<cmd>:w<cr>', { desc = 'Save current file' })
vim.keymap.set(
  'n',
  '<leader>ld',
  ':lua vim.diagnostic.open_float()<cr>',
  { desc = 'Open diagnostic float' }
)
vim.keymap.set(
  'n',
  '<C-h>',
  '<C-w><C-h>',
  { desc = 'Move focus to the left window' }
)
vim.keymap.set(
  'n',
  '<C-l>',
  '<C-w><C-l>',
  { desc = 'Move focus to the right window' }
)
vim.keymap.set(
  'n',
  '<C-j>',
  '<C-w><C-j>',
  { desc = 'Move focus to the lower window' }
)
vim.keymap.set(
  'n',
  '<C-k>',
  '<C-w><C-k>',
  { desc = 'Move focus to the upper window' }
)

vim.keymap.set('n', ']b', '<cmd>bn<cr>', { desc = 'Move to next buffer' })
vim.keymap.set('n', '[b', '<cmd>bp<cr>', { desc = 'Move to previous buffer' })

vim.keymap.set('n', '<A-j>', function()
  vim.cmd 'm .+1'
end, { desc = 'Move: move current line down' })

vim.keymap.set('n', '<A-k>', function()
  vim.cmd 'm .-2'
end, { desc = 'Move: move current line down' })
vim.keymap.set('v', '<A-j>', function()
  vim.cmd "m '>+1"
end, { desc = 'Move: move current line down' })
vim.keymap.set('v', '<A-k>', function()
  vim.cmd "m '<-2"
end, { desc = 'Move: move current block down' })

vim.keymap.set('n', '<A-k>', ':m .-2<CR>==') -- move line down(n)
vim.keymap.set('v', '<A-j>', '') -- move line up(v)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv") -- move line down(v)

vim.keymap.set('v', '<C-d>', '<C-d>zz') -- scroll down and center it
vim.keymap.set('v', '<C-u>', '<C-u>zz') -- scroll up and center it

if os.getenv 'TMUX' then
  vim.keymap.set('n', '<leader>fp', function()
    os.execute "tmux split-window -v '/home/azharnazli/dotfile-main/script/tmux-sessionizer'"
  end, { desc = 'tmux-sessionizer in split' })

  vim.keymap.set('n', '<leader>nx', function()
    os.execute 'tmux kill-window'
  end, { desc = 'Kill tmux window' })
end

-- You can also specify a list of valid jump keywords
vim.keymap.set(
  'n',
  '<c-q>',
  keymap_helper.toggle_quickfix,
  { desc = 'Toggle Quickfix Window' }
)

-- Resize buffer width with Ctrl + Arrow keys
vim.keymap.set(
  'n',
  '<C-Left>',
  ':vertical resize -2<CR>',
  { noremap = true, silent = true, desc = 'Resize width -2' }
)
vim.keymap.set(
  'n',
  '<C-Right>',
  ':vertical resize +2<CR>',
  { noremap = true, silent = true, desc = 'Resize width +2' }
)
vim.keymap.set(
  'n',
  '<C-Up>',
  ':resize +2<CR>',
  { noremap = true, silent = true, desc = 'Resize height +2' }
)
vim.keymap.set(
  'n',
  '<C-Down>',
  ':resize -2<CR>',
  { noremap = true, silent = true, desc = 'Resize height -2' }
)

vim.keymap.set(
  'n',
  '<leader>gd',
  ':CodeDiff file HEAD<cr>',
  { noremap = true, silent = true, desc = 'Codediff current file' }
)

vim.keymap.set(
  'n',
  '<leader>gD',
  ':CodeDiff<cr>',
  { noremap = true, silent = true, desc = 'Codediff current all' }
)

--auto command
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup(
    'kickstart-highlight-yank',
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})
