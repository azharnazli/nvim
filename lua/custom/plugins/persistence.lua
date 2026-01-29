return {
  'olimorris/persisted.nvim',
  lazy = false,
  opts = {
    autostart = true, -- Automatically start the plugin on load?
    ---@type fun(): boolean
    should_save = function()
      return true
    end,

    save_dir = vim.fn.expand(vim.fn.stdpath 'data' .. '/sessions/'), -- Directory where session files are saved

    follow_cwd = true, -- Change the session file to match any change in the cwd?
    use_git_branch = false, -- Include the git branch in the session file name?
    autoload = true, -- Automatically load the session for the cwd on Neovim startup?

    -- Function to run when `autoload = true` but there is no session to load
    ---@type fun(): any
    on_autoload_no_session = function() end,

    allowed_dirs = {}, -- Table of dirs that the plugin will start and autoload from
    ignored_dirs = {}, -- Table of dirs that are ignored for starting and autoloading
  },
  keys = {
    {
      '<leader>Pr',
      function()
        require('persisted').load()
      end,
      desc = 'persisted: load session',
    },
    {
      '<leader>Ps',
      function()
        require('persisted').select()
      end,
      desc = 'persisted: select session',
    },
    {
      '<leader>Pl',
      function()
        require('persisted').load { last = true }
      end,
      desc = 'persisted: load last session',
    },
    {
      '<leader>PS',
      function()
        require('persisted').stop()
      end,
      desc = 'Persisted: Stop recording a session',
    },
    {
      '<leader>Pa',
      function()
        require('persisted').stop()
      end,
      desc = 'Persisted: Start recording a session',
    },
    {
      '<leader>PD',
      function()
        require('persisted').delete()
      end,
      desc = 'Persisted: Delete a session from a list',
    },
    {
      '<leader>Pd',
      function()
        require('persisted').delete_current()
      end,
      desc = 'Persisted: Delete the current session',
    },
    {
      '<leader>Pt',
      function()
        require('persisted').toggle()
      end,
      desc = 'Persisted: Determines whether to load, start or stop a session',
    },
  },
}
