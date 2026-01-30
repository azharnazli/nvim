local m = {}

-- Toggel Qf
m.toggle_quickfix = function()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win['quickfix'] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

-- Reload Neovim Config
m.reload_config = function()
  local namespace = 'user' -- e.g. lua/user/*.lua

  for name, _ in pairs(package.loaded) do
    if name:match('^' .. namespace) then
      package.loaded[name] = nil
    end
  end

  local init = vim.fn.stdpath 'config' .. '/init.lua'
  dofile(init)

  vim.notify('Neovim config reloaded!', vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local ok, wk_title = pcall(require, 'wk_title')
    if ok then
      wk_title.register_titles()
    end
  end,
})

-- Close all buffers except current
m.close_other_buffer = function()
  local current = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    local is_term = vim.api.nvim_buf_get_name(buf):match 'toggleterm'
    local is_neo = vim.api.nvim_buf_get_name(buf):match 'neo%-tree'

    if buf ~= current and not is_term and not is_neo then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Run Project
m.run_project = function()
  local project_dir = vim.fn.getcwd()
  local script = project_dir .. '/run.sh'

  if vim.fn.filereadable(script) == 0 then
    vim.notify('No run.sh in project', vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({ 'zsh', script }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.notify(table.concat(data, '\n'), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR)
      end
    end,
  })
end

-- Run Project in tmux right 35%
m.tmux_pane_right = function()
  local project_dir = vim.fn.getcwd()
  local script = project_dir .. '/run.sh'

  if vim.fn.filereadable(script) == 0 then
    vim.notify('No run.sh in project', vim.log.levels.ERROR)
    return
  end

  if not vim.env.TMUX or vim.env.TMUX == '' then
    vim.notify('Not inside a tmux session', vim.log.levels.ERROR)
    return
  end

  local out = vim.fn.system {
    'tmux',
    'split-window',
    '-h',
    '-p',
    '35',
    '-c',
    project_dir,
    'zsh',
    '-c',
    script .. '; exec zsh',
  }

  if vim.v.shell_error ~= 0 then
    vim.notify(
      'tmux split-window failed: ' .. (out or ''),
      vim.log.levels.ERROR
    )
  end
end

return m
