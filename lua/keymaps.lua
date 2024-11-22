vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set(
  'n',
  '<c-q>',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic Quickfix list' }
)

vim.keymap.set('n', '<leader>c', function()
  require('mini.bufremove').delete()
end, { desc = 'Close Current Buffer' })

vim.keymap.set('n', '<leader>bc', function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local term = false
    local neoBuf = nil
    if vim.api.nvim_buf_get_name(buf):match 'toggleterm' then
      term = true
    end
    if vim.api.nvim_buf_get_name(buf):match 'neo%-tree' then
      neoBuf = buf
    end
    if buf ~= neoBuf and not term and buf ~= vim.g.last then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = 'Close All Buffer Except Current Buffer' })

vim.keymap.set('n', '<leader>bl', function()
  vim.cmd('e ' .. vim.g.last_path)
end, { desc = 'Resume last close buffer' })

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

vim.keymap.set('n', '<A-j>', ':m .+1<CR>==') -- move line up(n)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==') -- move line down(n)
vim.keymap.set('v', '<A-j>', '') -- move line up(v)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv") -- move line down(v)

vim.keymap.set('v', '<C-d>', '<C-d>zz') -- scroll down and center it
vim.keymap.set('v', '<C-u>', '<C-u>zz') -- scroll up and center it

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- You can also specify a list of valid jump keywords

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next { keywords = { 'ERROR', 'WARNING' } }
end, { desc = 'Next error/warning todo comment' })

local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win['quickfix'] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

vim.keymap.set(
  'n',
  '<c-q>',
  toggle_quickfix,
  { desc = 'Toggle Quickfix Window' }
)

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
