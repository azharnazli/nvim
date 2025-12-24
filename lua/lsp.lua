vim.lsp.enable {
  'lua_ls',
  'vtsls',
  'tailwindcss',
  'zls',
  'eslint_lsp',
  'rust',
  'golang',
  'cpp',
  'cmake',
  'meson',
}

vim.diagnostic.config {
  virtual_text = true,
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
