return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerRun',
    'OverseerToggle',
    'OverseerOpen',
    'OverseerClose',
    'OverseerSaveBundle',
    'OverseerLoadBundle',
    'OverseerDeleteBundle',
    'OverseerQuickAction',
    'OverseerTaskAction',
    'OverseerBuild',
  },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    dap = false,
  },
}
