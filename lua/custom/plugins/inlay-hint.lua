return {
  {
    'MysticalDevil/inlay-hints.nvim',
    event = 'LspAttach',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      local ih = require 'inlay-hints'

      ih.setup {
        only_current_line = false,
        eol = false,
        enabled_at_startup = false,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- Ensure hints are OFF initially
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end

          -- Manual Toggle using the native Neovim API
          vim.keymap.set('n', '<leader>lh', function()
            local is_enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
          end, { buffer = bufnr, desc = 'Toggle inlay hints' })
        end,
      })
    end,
  },
}
