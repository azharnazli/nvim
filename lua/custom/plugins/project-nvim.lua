return {
  'DrKJeff16/project.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'ibhagwan/fzf-lua',
  },
  keys = {
    -- The main search commands
    { '<leader>pf', '<cmd>ProjectFzf<cr>', desc = 'Find Projects (FZF)' },
    {
      '<leader>pt',
      '<cmd>ProjectTelescope<cr>',
      desc = 'Find Projects (Telescope)',
    },

    -- Project Management
    { '<leader>pp', '<cmd>Project<cr>', desc = 'Projects Menu' },
    { '<leader>pa', '<cmd>ProjectAdd<cr>', desc = 'Add Project' },
    { '<leader>pd', '<cmd>ProjectDelete<cr>', desc = 'Delete Project' },
    { '<leader>pr', '<cmd>ProjectRoot<cr>', desc = 'Project Root' },
    { '<leader>ps', '<cmd>ProjectSession<cr>', desc = 'Project Session' },

    -- Config & JSON
    { '<leader>pc', '<cmd>ProjectConfig<cr>', desc = 'Project Config' },
    {
      '<leader>pxj',
      '<cmd>ProjectExportJSON<cr>',
      desc = 'Export Projects JSON',
    },
    {
      '<leader>pij',
      '<cmd>ProjectImportJSON<cr>',
      desc = 'Import Projects JSON',
    },

    -- Maintenance & Logs
    { '<leader>ph', '<cmd>ProjectHealth<cr>', desc = 'Project Health' },
    { '<leader>py', '<cmd>ProjectHistory<cr>', desc = 'Project History' },
    { '<leader>pl', '<cmd>ProjectLog<cr>', desc = 'Project Log' },
    { '<leader>pL', '<cmd>ProjectLogClear<cr>', desc = 'Clear Project Log' },
  },
  opts = {},
}
