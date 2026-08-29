return {
  'phantumblade/projecthub.nvim',
  -- Every command that should work before the dashboard has been opened once
  -- must be listed here, otherwise lazy.nvim has nothing to load the plugin on.
  cmd = {
    'ProjectHub',
    'PH',
    'ProjectHubLang',
    'PHLang',
    'PHl',
    'ProjectHubSound',
    'PHSound',
    'ProjectHubStars',
    'PHStars',
    'PHStarsDemo',
    'PHStarsCheck',
    'PHStarsRehearse',
    'ProjectHubNotify',
    'PHNotify',
  },
  keys = {
    { '<leader>P', '<cmd>ProjectHub<cr>', desc = 'ProjectHub Dashboard' },
  },
  opts = {
    language = 'en', -- "en" or "it" (switchable anytime with 'L' or :ProjectHubLang)
    -- Folders to scan: { path, search_depth }
    roots = {
      { '~/Projects', 1 },
      { '~/Work', 2 },
    },
    -- Individual project folders outside roots
    extra = {
      '~/.config/nvim',
    },
    -- Your GitHub/GitLab usernames (for owner badge & author filtering)
    me = {
      owners = { 'azharnazli' },
    },
    -- UI Sound Effects (uisfx minimal preset)
    sound = {
      enabled = false, -- set false to disable all sounds
      volume = 0.0, -- volume level (0.0 to 1.0)
    },
  },
}
