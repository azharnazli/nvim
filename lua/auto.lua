vim.g.last = 0
vim.g.last_path = ''

-- vim.api.nvim_create_user_command('EslintFixAll', function()
--   vim.cmd 'write' -- Save the file before fixing
--   local filename = vim.fn.expand '%:p' -- Get full path of current file
--   vim.fn.jobstart({ 'eslint_d', '--fix', filename }, {
--     on_exit = function(_, code)
--       if code == 0 then
--         print 'ESLint fix applied successfully!'
--         vim.cmd 'edit' -- Reload buffer to reflect changes
--       else
--         print 'ESLint fix failed! Check your ESLint setup.'
--       end
--     end,
--   })
-- end, {})

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
