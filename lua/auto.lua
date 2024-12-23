vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'run caps',
  callback = function()
    if vim.fn.has 'wsl' == 1 then
      vim.fn.jobstart './caps.exe'
    end
  end,
})

if vim.fn.has 'wsl' == 1 then
  vim.api.nvim_create_user_command('CapsReset', function()
    vim.fn.jobstart 'pkill caps'
    vim.defer_fn(function()
      vim.fn.jobstart './caps.exe'
    end, 100)
  end, {})
end
