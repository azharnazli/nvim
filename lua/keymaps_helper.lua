local m = {}

m.remove_ansi_codes = function()
  local view = vim.fn.winsaveview()

  vim.cmd [[
    silent! keeppatterns %s/\%x1b\[[0-9;]*[A-Za-z]//ge
  ]]

  vim.fn.winrestview(view)
end

m.clean_print_log = function()
  local view = vim.fn.winsaveview()

  vim.cmd [[
    silent! keeppatterns %s/\r//ge
  ]]

  vim.cmd [[
    silent! keeppatterns %s/\%x1b\[[0-9;]*[A-Za-z]//ge
  ]]

  vim.fn.winrestview(view)
end

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

    if buf ~= current and not is_term then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Run Project
m.run_project = function()
  local script = vim.fn.getcwd() .. '/run.sh'
  local Terminal = require('toggleterm.terminal').Terminal

  local width = math.floor(vim.o.columns * 0.4)

  local term = Terminal:new {
    cmd = 'bash ' .. vim.fn.fnameescape(script),
    direction = 'vertical', -- right/left depends on splitright
    close_on_exit = false,
    name = 'run_project',
  }

  vim.opt.splitright = true -- ensure it opens on the right
  term:open()

  -- hard-force the width after opening
  if term.window and vim.api.nvim_win_is_valid(term.window) then
    vim.api.nvim_win_set_width(term.window, width)
  end
end

-- Run current buffer with bun (TS/JS only)
m.run_bun = function()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  -- Only TS/JS buffers can be run with bun
  local bun_filetypes = {
    typescript = true,
    typescriptreact = true,
    javascript = true,
    javascriptreact = true,
  }
  if not bun_filetypes[vim.bo[buf].filetype] then
    vim.notify(
      'bun: current buffer is not a TS/JS file (' .. vim.bo[buf].filetype .. ')',
      vim.log.levels.WARN
    )
    return
  end

  local Terminal = require('toggleterm.terminal').Terminal
  local term = Terminal:new {
    cmd = 'bun run ' .. vim.fn.fnameescape(file),
    direction = 'horizontal', -- open a terminal at the bottom
    close_on_exit = false,
    name = 'run_bun',
  }
  term:open()
end

return m
