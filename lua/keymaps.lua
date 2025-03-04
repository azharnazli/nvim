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

vim.keymap.set({ 'n', 't' }, '<c-\\>', function()
  local terminal = require('toggleterm.terminal').Terminal
  local term1 = terminal:new { id = 1 }
  term1:toggle()
end, { desc = 'Toggle Main Terminal' })

vim.keymap.set({ 'n', 't' }, '<c-t>1', function()
  local terminal = require('toggleterm.terminal').Terminal
  local term1 = terminal:new { id = 2 }
  term1:toggle(10, 'horizontal')
end, { desc = 'Toggle Secondary Terminal' })

vim.keymap.set({ 'n', 't' }, '<c-t>2', function()
  local terminal = require('toggleterm.terminal').Terminal
  local term1 = terminal:new { id = 3 }
  term1:toggle(50, 'vertical')
end, { desc = 'Toggle Secondary Terminal' })

-- Resize buffer width with Ctrl + Arrow keys
vim.api.nvim_set_keymap(
  'n',
  '<C-Left>',
  ':vertical resize -2<CR>',
  { noremap = true, silent = true, desc = 'Resize width -2' }
)
vim.api.nvim_set_keymap(
  'n',
  '<C-Right>',
  ':vertical resize +2<CR>',
  { noremap = true, silent = true, desc = 'Resize width +2' }
)
vim.api.nvim_set_keymap(
  'n',
  '<C-Up>',
  ':resize +2<CR>',
  { noremap = true, silent = true, desc = 'Resize height +2' }
)
vim.api.nvim_set_keymap(
  'n',
  '<C-Down>',
  ':resize -2<CR>',
  { noremap = true, silent = true, desc = 'Resize height -2' }
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf', -- Trigger only in Quickfix windows
  callback = function()
    vim.keymap.set('n', '<leader>uq', function()
      -- Get input from the user
      local old_text = vim.fn.input 'Text to replace: '
      if old_text == '' then
        print 'No text provided to replace.'
        return
      end
      local new_text = vim.fn.input 'Replace with: '

      local qlist = vim.fn.getqflist()
      for _, item in ipairs(qlist) do
        item.text = item.text:gsub(old_text, new_text) -- Replace old_text with new_text
      end
      vim.fn.setqflist(qlist, 'r') -- Update the Quickfix list
      print 'Quickfix list updated!'
    end, { buffer = true, desc = 'Update Quickfix list with input text' })
  end,
})
