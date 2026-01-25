vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local ok, wk_title = pcall(require, 'wk_title')
    if ok then
      wk_title.register_titles()
    end
  end,
})

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

vim.keymap.set('n', '<leader>bD', function()
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    local is_term = vim.api.nvim_buf_get_name(buf):match 'toggleterm'
    local is_neo = vim.api.nvim_buf_get_name(buf):match 'neo%-tree'

    if buf ~= current and not is_term and not is_neo then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = 'Close all buffers except current' })

vim.keymap.set('n', '<leader>bl', function()
  vim.cmd('e ' .. vim.g.last_path)
end, { desc = 'Resume last close buffer' })

vim.keymap.set('n', '<leader>nr', function()
  vim.cmd('source ' .. vim.env.MYVIMRC)
  vim.cmd('luafile ' .. vim.env.MYVIMRC)
  print 'Config Reloaded!'
end)

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
