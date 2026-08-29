local keymap_helper = require 'keymaps_helper'

vim.keymap.set(
  'n',
  '<leader>pr',
  keymap_helper.run_project,
  { desc = 'Project: Run Project' }
)

vim.keymap.set('n', '<leader>fG', function()
  vim.cmd 'GitChangedFzf'
end, { desc = 'Find: Changed Update File' })

vim.keymap.set({ 'n', 'i', 'v' }, '<C-c>', function()
  if _G.vim_state.hard_mode then
    return
  end
  return '<Esc>'
end, { expr = true, silent = true })

vim.keymap.set('n', '<leader>nX', function()
  _G.vim_state.hard_mode = not _G.vim_state.hard_mode
end, { desc = 'Toggle Hardmode' })

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
  keymap_helper.close_other_buffer,
  { desc = 'Close all buffers except current' }
)

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

vim.keymap.set('n', '[b', '<cmd>bn<cr>', { desc = 'Move to next buffer' })
vim.keymap.set('n', ']b', '<cmd>bp<cr>', { desc = 'Move to previous buffer' })

-- Guard: move-line only runs in a real, editable editor buffer. Terminal
-- buffers (fzf, lazygit, ...), prompt/quickfix buffers, unmodifiable buffers,
-- and floating windows (fzf popup, which-key, ...) have their own <A-j>/<A-k>
-- handling, so we let the keys fall through to them instead of moving a line.
local function in_editor()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  -- Terminal / prompt / quickfix buffers own the keys
  if vim.bo[buf].buftype ~= '' then
    return false
  end
  -- Readonly or otherwise non-editable buffer
  if not vim.bo[buf].modifiable then
    return false
  end
  -- Floating windows (fzf, which-key, notify, ...) own the keys
  if vim.api.nvim_win_get_config(win).relative ~= '' then
    return false
  end
  return true
end

local function move_line(fmt)
  if in_editor() then
    vim.cmd(fmt)
  end
end

vim.keymap.set('n', '<A-j>', function()
  move_line 'm .+1'
end, { desc = 'Move: move current line down' })
vim.keymap.set('n', '<A-k>', function()
  move_line 'm .-2'
end, { desc = 'Move: move current line up' })

-- Visual mode must use the command-line (string) form, not vim.cmd: the '<,'>
-- range is only applied when ':' is entered from visual mode, and the '< '>
-- marks aren't readable inside a vim.cmd callback (E20: Mark not set). The
-- leading ':' makes Vim auto-apply the selection range; 'gv' re-selects.
vim.keymap.set('v', '<A-j>', function()
  if in_editor() then
    return vim.api.nvim_replace_termcodes(":m '>+1<CR>gv", false, false, true)
  end
  return ''
end, { expr = true, desc = 'Move: move selected lines down' })
vim.keymap.set('v', '<A-k>', function()
  if in_editor() then
    return vim.api.nvim_replace_termcodes(":m '<-2<CR>gv", false, false, true)
  end
  return ''
end, { expr = true, desc = 'Move: move selected lines up' })

vim.keymap.set('v', '<C-d>', '<C-d>zz') -- scroll down and center it
vim.keymap.set('v', '<C-u>', '<C-u>zz') -- scroll up and center it

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

-- Toggle lazygit: floating popup via the herdr-lazygit plugin when Neovim runs
-- inside Herdr, otherwise fall back to the installed lazygit.nvim.
vim.keymap.set('n', '<leader>gg', function()
  if vim.env.HERDR_ENV == '1' then
    local herdr_bin = vim.env.HERDR_BIN_PATH or 'herdr'
    vim.system(
      { herdr_bin, 'plugin', 'action', 'invoke', 'open', '--plugin', 'herdr-lazygit' },
      { text = true },
      function(out)
        if out.code ~= 0 then
          vim.notify(
            'herdr: failed to toggle lazygit popup: ' .. (out.stderr or ''),
            vim.log.levels.ERROR
          )
        end
      end
    )
  else
    vim.cmd 'Lazygit'
  end
end, { desc = 'Git: toggle lazygit (Herdr floating popup / built-in)' })

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

vim.keymap.set(
  'n',
  '<leader>pa',
  keymap_helper.remove_ansi_codes,
  { desc = 'Print: Remove ANSI codes' }
)

vim.keymap.set(
  'n',
  '<leader>pc',
  keymap_helper.clean_print_log,
  { desc = 'Print: Clean CR and ANSI codes' }
)
