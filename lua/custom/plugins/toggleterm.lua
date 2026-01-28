local ui = vim.api.nvim_list_uis()[1]
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    open_mapping = nil,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- white border for floating terminal
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#ffffff' }) -- white
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'None' }) -- optional transparency
  end,
  keys = {
    {
      '<C-\\>',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        local fullscreen = Terminal:new {
          direction = 'float',
          float_opts = {
            border = 'single', -- square + non-curved
            width = 150,
            height = 40,
          },
          hidden = true,
          id = 1,
        }
        fullscreen:toggle()
      end,
      mode = { 'n', 't' },
      desc = 'Toggle Fullscreen Terminal',
    },
  },
}
