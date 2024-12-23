vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'run caps',
  callback = function()
    if vim.fn.has 'wsl' == 1 then
      vim.fn.jobstart './caps.exe'
    end
  end,
})
