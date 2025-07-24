return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 2000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        nix = { 'nixfmt' },
        lua = { 'stylua' },
        json = { 'prettierd', stop_after_first = true },
        jsonc = { 'prettierd', stop_after_first = true },
        typescript = { 'prettierd', stop_after_first = true },
        typescriptreact = { 'prettierd', stop_after_first = true },
        javascript = { 'prettierd', stop_after_first = true },
        javascriptreact = { 'prettierd', stop_after_first = true },
        html = { 'prettierd', stop_after_first = true },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
