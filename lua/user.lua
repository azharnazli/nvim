vim.api.nvim_create_user_command('GitChanged', function()
  local result = vim
    .system({ 'git', 'diff', '--name-only', '--diff-filter=d' }, { text = true })
    :wait()

  local files = vim.split(result.stdout, '\n', { trimempty = true })

  local qf = {}
  for _, file in ipairs(files) do
    table.insert(qf, {
      filename = file,
      lnum = 1,
    })
  end

  vim.fn.setqflist(qf, 'r')
  vim.cmd 'copen'
end, {})

vim.api.nvim_create_user_command('GitChangedFzf', function()
  local root = vim
    .system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true })
    :wait().stdout
  root = (root or ''):gsub('%s+$', '')
  if root == '' then
    return vim.notify('Not inside a git repo', vim.log.levels.WARN)
  end

  require('fzf-lua').git_status {
    cwd = root,
    prompt = 'Git status> ',
    -- this is usually the default preview for git_status, but explicit is fine:
    previewer = 'git_diff',
  }
end, {})
