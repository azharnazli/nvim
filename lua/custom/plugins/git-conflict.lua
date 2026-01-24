return {
  'akinsho/git-conflict.nvim',
  opts = {
    default_commands = true, -- disable commands created by this plugin
    disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
    list_opener = 'copen', -- command or function to open the conflicts list
    highlights = { -- They must have background color, otherwise the default color will be used
      current = 'DiffText',
      incoming = 'DiffAdd',
    },
  },
}
