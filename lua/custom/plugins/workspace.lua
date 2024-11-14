return {
  'natecraddock/workspaces.nvim',
  config = function()
    local workspace = require 'workspaces'
    workspace.setup {
      hooks = {
        open = { 'Telescope find_files' },
      },
    }
    local map = vim.keymap.set

    local list_workspace = workspace.get()
    local current_index = 1
    vim.g.current_index = current_index
    local names = {}
    vim.g.dir_names = names

    map('n', '<leader>wl', function()
      workspace.open()
    end, { desc = 'List All Workspace' })

    map('n', '<leader>wa', function()
      local path = vim.fn.getcwd()
      local name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      workspace.add(path, name)
    end, { desc = 'Append a Workspace' })

    map('n', '<leader>wD', function()
      local path = vim.fn.getcwd()
      workspace.remove_dir(path)
    end, { desc = 'Remove current Workspace' })
  end,
}
