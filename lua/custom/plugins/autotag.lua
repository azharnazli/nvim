return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPost', 'BufNewFile' },
  ft = {
    'html',
    'javascriptreact',
    'typescriptreact',
    'xml',
    'svelte',
    'vue',
    'tsx',
    'jsx',
  },
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
      -- per_filetype = {
      --   ['html'] = {
      --     enable_close = false,
      --   },
      -- },
    }
  end,
}
