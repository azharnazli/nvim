return {
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
    require('lsp_lines').setup()
    local enable = false
    vim.keymap.set('n', '<leader>lf', function()
      enable = not enable
    end, { desc = 'Toggle lsp line' })

    vim.diagnostic.config { virtual_text = false }
    local function show_diagnostics_for_cursor()
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
      if #diagnostics > 0 and enable then
        vim.diagnostic.config { virtual_lines = true }
      else
        vim.diagnostic.config { virtual_lines = false }
      end
    end

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorMoved' }, {
      callback = show_diagnostics_for_cursor,
    })
  end,
}
