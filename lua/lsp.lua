vim.lsp.enable {
  'lua_ls',
  'vtsls',
  'tailwindcss',
  'zls',
  'eslint_lsp',
}

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = true,
  underline = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  update_in_insert = false,
  severity_sort = true,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'javascript',
    'javascriptreact',
    'javascript.jsx',
  },
  callback = function(args)
    local buf = args.buf
    local bufname = vim.api.nvim_buf_get_name(buf)

    -- Check for Node/TS
    local node_root = vim.fs.find(
      { 'tsconfig.json', 'jsconfig.json' },
      { upward = true, path = bufname }
    )[1]
    if node_root then
      vim.lsp.enable 'vtsls'
      return
    end
  end,
})
