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

local isLuna = pcall(require, 'luna')
if isLuna then
  vim.cmd.colorscheme 'luna'
end

local current_file = vim.api.nvim_buf_get_name(0)
local go_mod = vim.fs.find('go.mod', { path = current_file, upward = true })

if go_mod then
  vim.api.nvim_create_user_command('GoModTidy', function()
    vim.fn.jobstart({ 'go', 'mod', 'tidy' }, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify('go mod tidy completed', vim.log.levels.INFO)
          vim.cmd 'lsp restart'
        else
          vim.notify('go mod tidy failed', vim.log.levels.ERROR)
        end
      end,
    })
  end, {})

  vim.keymap.set(
    'n',
    '<leader>pg',
    ':GoModTidy<cr>',
    { silent = true, desc = 'tidy and restart lsp' }
  )
end
