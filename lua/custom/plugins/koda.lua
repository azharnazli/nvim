return {
  'oskarnurm/koda.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- require("koda").setup({ transparent = true })
    require('koda').setup {
      colors = {
        bg = '#000000',
      },
    }
    vim.cmd 'colorscheme koda'
  end,
}
