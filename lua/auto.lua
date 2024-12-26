vim.g.last = 0
vim.g.last_path = ''
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Check current bufenter',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(buf):match 'toggleterm' then
      print('ini' .. vim.fn.bufname(buf))
    end
    if
      not vim.api.nvim_buf_get_name(buf):match 'neo%-tree'
      and vim.api.nvim_buf_get_name(buf) ~= ''
      and vim.api.nvim_buf_get_name(buf) ~= nil
    then
      vim.g.last = buf
      vim.g.last_path = vim.fn.bufname(buf)
    end
  end,
})

local uv = vim.uv or vim.loop
local sysname = uv.os_uname().sysname

if sysname == 'Linux' then
  local caps_path = vim.fn.stdpath 'config' .. '/caps'
  vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'run caps',
    callback = function()
      vim.fn.jobstart(caps_path)
    end,
  })
end

if vim.fn.has 'wsl' == 1 or sysname == 'Windows_NT' then
  local caps_path = vim.fn.stdpath 'config' .. '/caps.exe'
  vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'run caps',
    callback = function()
      vim.fn.jobstart(caps_path)
    end,
  })

  vim.api.nvim_create_user_command('CapsReset', function()
    vim.fn.jobstart 'pkill caps'
    vim.defer_fn(function()
      vim.fn.jobstart(caps_path)
    end, 100)
  end, {})
end
