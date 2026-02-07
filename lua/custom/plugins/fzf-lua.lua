return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function(_, opts)
    local fzf = require 'fzf-lua'
    local actions = fzf.actions

    -- keep your existing opts table if Lazy already passed one
    opts = opts or {}

    -- your fd options
    opts.files = vim.tbl_deep_extend('force', opts.files or {}, {
      fd_opts = '--color=never --type f --hidden --follow '
        .. '--exclude .git '
        .. '--exclude .zig-cache '
        .. '--exclude node_modules '
        .. '--exclude build '
        .. '--exclude .cache '
        .. '--exclude dist '
        .. '--exclude target '
        .. '--exclude .next '
        .. '--exclude .turbo '
        .. '--exclude .env '
        .. '--exclude .env.local',
    })

    -- fullscreen window
    opts.winopts = vim.tbl_deep_extend('force', opts.winopts or {}, {
      fullscreen = true,
    })

    -- fzf keymaps
    opts.keymap = opts.keymap or {}
    opts.keymap.fzf = vim.tbl_extend('force', opts.keymap.fzf or {}, {
      ['alt-j'] = 'down',
      ['alt-k'] = 'up',
      -- select all entries and accept → fzf-lua will send them to quickfix
      ['ctrl-q'] = 'select-all+accept',
    })

    -- actions: make grep nice (optional, but explicit)
    opts.actions = opts.actions or {}
    opts.actions.files = opts.actions.files
      or {
        -- open 1 file, or send multiple to quickfix (fzf-lua default)
        ['default'] = actions.file_edit_or_qf,
        ['ctrl-s'] = actions.file_split,
        ['ctrl-v'] = actions.file_vsplit,
        ['ctrl-t'] = actions.file_tabedit,
        ['alt-q'] = actions.file_sel_to_qf,
      }

    -- grep provider uses the same “file” actions by default,
    -- but you can override / make it explicit if you want:
    opts.grep = vim.tbl_deep_extend('force', opts.grep or {}, {
      actions = {
        ['default'] = actions.file_edit_or_qf, -- 1 result = jump, many = QF
        ['alt-q'] = actions.file_sel_to_qf, -- manual “send selected to QF”
      },
    })

    return opts
  end,
  keys = {
    {
      '<leader>ff',
      '<cmd>lua require("fzf-lua").files()<cr>',
      desc = 'Find files',
    },
    -- Toggle hidden/ignored files with dot
    {
      '<leader>fF',
      function()
        require('fzf-lua').files {
          prompt = 'Files (all)❯ ',
          fd_opts = '--color=never --type f --hidden --follow --no-ignore',
        }
      end,
      desc = 'Find files (all)',
    },
    {
      '<leader>fw',
      '<cmd>lua require("fzf-lua").live_grep()<cr>',
      desc = 'Live grep',
    },
    {
      '<leader>fg',
      '<cmd>lua require("fzf-lua").grep_cword()<cr>',
      desc = 'Grep word',
    },
    {
      '<leader>fo',
      function()
        require('fzf-lua').oldfiles {
          cwd_only = true,
        }
      end,
      desc = 'Recent files',
    },
    {
      '<leader>fb',
      '<cmd>lua require("fzf-lua").buffers()<cr>',
      desc = 'Buffers',
    },
    {
      '<leader>fh',
      '<cmd>lua require("fzf-lua").helptags()<cr>',
      desc = 'Help tags',
    },
    {
      '<leader>fk',
      '<cmd>lua require("fzf-lua").keymaps()<cr>',
      desc = 'Keymaps',
    },
    {
      '<leader>f<CR>',
      '<cmd>lua require("fzf-lua").resume()<cr>',
      desc = 'Resume search',
    },
    {
      '<leader>lD',
      '<cmd>lua require("fzf-lua").diagnostics_document()<cr>',
      desc = 'Document Diagnostics',
    },
    {
      '<leader>lW',
      '<cmd>lua require("fzf-lua").diagnostics_document()<cr>',
      desc = 'Document Diagnostics',
    },
  },
  config = function(_, opts)
    require('fzf-lua').setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'fzf',
      callback = function()
        -- These mappings force Neovim to send the keys to the terminal (fzf)
        -- instead of triggering your global "move line" or editing maps.
        vim.keymap.set('t', '<A-j>', '<A-j>', { buffer = true, nowait = true })
        vim.keymap.set('t', '<A-k>', '<A-k>', { buffer = true, nowait = true })
      end,
    })
  end,
}
