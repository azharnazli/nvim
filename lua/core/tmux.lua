if vim.env.TMUX then
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local base_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  if base_name == 'azharnazli' then
    base_name = 'zsh'
  end

  local current_id = vim.fn.trim(
    vim.fn.system { 'tmux', 'display-message', '-p', '#{window_id}' }
  )
  if vim.v.shell_error ~= 0 or current_id == '' then
    return
  end

  local tmux_output = vim.fn.system {
    'tmux',
    'list-windows',
    '-F',
    '#{window_name} #{window_id}',
  }
  if vim.v.shell_error ~= 0 or tmux_output == '' then
    return
  end

  local target_id = nil
  local taken_names = {}

  for line in tmux_output:gmatch '[^\r\n]+' do
    local name, id = line:match '^(%S+)%s+(%S+)$'
    if name and id then
      taken_names[name] = true

      if name == base_name and id ~= current_id then
        target_id = id
      end
    end
  end

  local final_name = base_name

  if target_id then
    local choice = vim.fn.confirm(
      "Window '" .. base_name .. "' is already open. Switch to it?",
      '&Yes\n&No (Create Duplicate)',
      1
    )

    if choice == 1 then
      vim.fn.system { 'tmux', 'select-window', '-t', target_id }
      vim.fn.system { 'tmux', 'kill-pane' } -- Kill the new pane we just opened
      return -- Stop loading Neovim
    else
      local counter = 1
      local candidate = base_name .. '_' .. counter

      while taken_names[candidate] do
        counter = counter + 1
        candidate = base_name .. '_' .. counter
      end

      final_name = candidate
    end
  end

  vim.fn.system { 'tmux', 'rename-window', final_name }
  --   vim.api.nvim_create_autocmd('ExitPre', {
  --     callback = function()
  --       local window_count = tonumber(
  --         vim.fn.trim(
  --           vim.fn.system { 'tmux', 'display-message', '-p', '#{session_windows}' }
  --         )
  --       )
  --       if window_count and window_count > 1 then
  --         vim.fn.system { 'tmux', 'kill-pane' }
  --       else
  --         vim.fn.system { 'tmux', 'rename-window', 'zsh' }
  --       end
  --     end,
  --   })
end
