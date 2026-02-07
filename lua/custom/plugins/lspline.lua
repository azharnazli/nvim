return {
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
    require('lsp_lines').setup()
    vim.diagnostic.config { virtual_text = false, virtual_lines = false }

    vim.keymap.set('n', '<leader>lf', function()
      local current = vim.diagnostic.config().virtual_lines
      if current then
        vim.diagnostic.config { virtual_lines = false }
        return
      end
      vim.diagnostic.config { virtual_lines = { only_current_line = true } }
    end, { desc = 'Toggle lsp line' })
  end,
}
