local M = {}

function M.register_titles()
  local ok, wk = pcall(require, 'which-key')

  if not ok then
    vim.notify('whichkey not found', vim.log.levels.ERROR)
    return
  end

  wk.add {
    { '<leader>a', name = 'Avante' },
    { '<leader>b', name = 'Buffer' },
    { '<leader>d', name = 'Debug' },
    { '<leader>g', name = 'Git Tools' },
    { '<leader>s', name = 'Neovim Tools' },
    { '<leader>x', name = 'Diagnostic Tools' },
  }
end

return M
