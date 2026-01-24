return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 50 }
      -- require('mini.surround').setup()
      require('mini.cursorword').setup()
      require('mini.indentscope').setup()
      require('mini.starter').setup()

      local files = require 'mini.files'

      files.setup {
        options = {
          use_as_default_explorer = false, -- Prevents auto-opening on startup
        },
        mappings = {
          close = 'q',
          go_in = 'l',
          go_in_plus = 'L',
          go_out = 'h',
          go_out_plus = 'H',
          mark_goto = "'",
          mark_set = 'm',
          reset = '.',
          reveal_cwd = '@',
          show_help = 'g?',
          synchronize = '=',
          trim_left = '<',
          trim_right = '>',
        },
        windows = {
          preview = true,
          width_focus = 50,
          width_nofocus = 15,
          width_preview = 25,
        },
      }

      local original_create = files.create
      files.create = function(...)
        original_create(...)
        vim.defer_fn(function()
          MiniFiles.synchronize()
        end, 10)
      end

      vim.keymap.set('n', '<leader>e', function()
        local state = files.get_explorer_state()
        if state ~= nil then
          return
        end
        local path
        local bufname = vim.api.nvim_buf_get_name(0)

        if bufname == '' then
          -- No file yet (e.g. just `nvim`)
          path = vim.fn.getcwd()
        elseif vim.fn.isdirectory(bufname) == 1 then
          -- Started as `nvim .` or opened a directory buffer
          path = bufname
        else
          -- Normal file buffer
          path = vim.fs.dirname(bufname)
        end

        files.open(path, true)
      end, { desc = 'Mini Files at current file dir' })

      vim.keymap.set('n', '<ESC>', function()
        files.close()
      end, { desc = 'Close Mini Explorer' })

      vim.keymap.set('n', '<Tab>', function()
        files.go_in { close_on_file = true }
      end, { desc = 'Mini file move in' })

      vim.keymap.set('n', '<CR>', function()
        files.go_in { close_on_file = true }
      end, { desc = 'Mini file move in' })

      vim.keymap.set('n', '<BS>', function()
        files.go_out()
      end, { desc = 'Mini file move back' })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
