-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        'debugloop/telescope-undo.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            'node_modules',
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'workspaces')
      pcall(require('telescope').load_extension, 'undo')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      local action_state = require 'telescope.actions.state'
      local actions = require 'telescope.actions'

      buffer_searcher = function()
        builtin.buffers {
          sort_mru = true,
          ignore_current_buffer = true,
          show_all_buffers = false,
          attach_mappings = function(prompt_bufnr, map)
            local refresh_buffer_searcher = function()
              actions.close(prompt_bufnr)
              vim.schedule(buffer_searcher)
            end

            local delete_buf = function()
              local selection = action_state.get_selected_entry()
              vim.api.nvim_buf_delete(selection.bufnr, { force = true })
              refresh_buffer_searcher()
            end

            local delete_multiple_buf = function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local selection = picker:get_multi_selection()
              for _, entry in ipairs(selection) do
                vim.api.nvim_buf_delete(entry.bufnr, { force = true })
              end
              refresh_buffer_searcher()
            end

            map('n', 'dd', delete_buf)
            map('n', '<C-d>', delete_multiple_buf)
            map('i', '<C-d>', delete_multiple_buf)

            return true
          end,
        }
      end

      vim.keymap.set(
        'n',
        '<leader>fh',
        builtin.help_tags,
        { desc = 'Find Help' }
      )
      vim.keymap.set(
        'n',
        '<leader>fk',
        builtin.keymaps,
        { desc = 'Find Keymaps' }
      )
      vim.keymap.set(
        'n',
        '<leader>ff',
        builtin.find_files,
        { desc = 'Find Files' }
      )

      vim.keymap.set('n', '<leader>fF', function()
        builtin.find_files { hidden = true, no_ignore = true }
      end, { desc = 'Find All Files' })

      vim.keymap.set(
        'n',
        '<leader>fs',
        builtin.builtin,
        { desc = 'Find Select Telescope' }
      )
      vim.keymap.set(
        'n',
        '<leader>fg',
        builtin.grep_string,
        { desc = 'Find current Word' }
      )
      vim.keymap.set(
        'n',
        '<leader>fw',
        builtin.live_grep,
        { desc = 'Find by Grep' }
      )
      vim.keymap.set(
        'n',
        '<leader>lD',
        builtin.diagnostics,
        { desc = 'Find Diagnostics' }
      )
      vim.keymap.set(
        'n',
        '<leader>f<return>',
        builtin.resume,
        { desc = 'Find Resume' }
      )
      vim.keymap.set(
        'n',
        '<leader>fo',
        builtin.oldfiles,
        { desc = 'Find Recent Files ("." for repeat)' }
      )
      vim.keymap.set(
        'n',
        '<leader>fb',
        buffer_searcher,
        { desc = 'Find existing buffers' }
      )

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        )
      end, { desc = '/ Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'Find / in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Find Neovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
