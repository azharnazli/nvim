return {
  {
    'MysticalDevil/inlay-hints.nvim',
    event = 'VeryLazy',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      autocmd = {
        enable = false,
      },
    },
    keys = {
      {
        '<leader>lf',
        function()
          local inlay_hints = require 'inlay-hints'
          -- Try different possible function names
          if inlay_hints.toggle then
            inlay_hints.toggle()
          elseif inlay_hints.toggle_inlay_hints then
            inlay_hints.toggle_inlay_hints()
          else
            -- Fallback to native Neovim inlay hints
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end
        end,
        desc = 'Toggle inlay hints',
      },
    },
  },
}
