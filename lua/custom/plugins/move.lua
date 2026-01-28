return {
  'fedepujol/move.nvim',
  config = function()
    local opts = { noremap = true, silent = true }
    require('move').setup {}

    -- Use <Cmd> instead of : to prevent UI flickering and mode-switching overhead
    vim.keymap.set('n', '<A-j>', '<Cmd>MoveLine(1)<CR>', opts)
    vim.keymap.set('n', '<A-k>', '<Cmd>MoveLine(-1)<CR>', opts)

    -- For Visual Mode, : is usually required for MoveBlock
    vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
    vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
  end,
}
