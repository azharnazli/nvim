-- Open a new Herdr pane to the right running nvim with the current buffer.
local function open_herdr_pane_with_current_buffer()
  if vim.env.HERDR_ENV ~= '1' then
    vim.notify('herdr-splits: not inside a Herdr session', vim.log.levels.WARN)
    return
  end

  local herdr_bin = vim.env.HERDR_BIN_PATH or 'herdr'

  -- Split the current pane to the right, preserving the working directory.
  local split = vim
    .system({ herdr_bin, 'pane', 'split', '--current', '--direction', 'right', '--cwd', vim.fn.getcwd() }, { text = true })
    :wait()

  if split.code ~= 0 then
    vim.notify('herdr-splits: pane split failed: ' .. (split.stderr or ''), vim.log.levels.ERROR)
    return
  end

  local ok, data = pcall(vim.json.decode, split.stdout)
  local pane_id = ok and data.result and data.result.pane and data.result.pane.pane_id
  if not pane_id then
    vim.notify('herdr-splits: could not read new pane id', vim.log.levels.ERROR)
    return
  end

  -- Open nvim in the new pane with the current buffer, or a plain nvim when the
  -- buffer has no readable file (e.g. a fresh unnamed buffer).
  local bufname = vim.api.nvim_buf_get_name(0)
  local cmd = (bufname ~= '' and vim.fn.filereadable(bufname) == 1) and ('nvim ' .. vim.fn.shellescape(bufname)) or 'nvim'
  local run = vim.system({ herdr_bin, 'pane', 'run', pane_id, cmd }, { text = true }):wait()
  if run.code ~= 0 then
    vim.notify('herdr-splits: pane run failed: ' .. (run.stderr or ''), vim.log.levels.ERROR)
  end
end

return {
  'lmilojevicc/herdr-splits.nvim',
  -- For local development, swap the repo line for `dir = '/path/to/herdr-splits'`
  -- (see "Local development" below).
  cond = vim.env.HERDR_ENV == '1',
  event = 'VeryLazy',
  -- Optional: auto-sync the Herdr-side scripts when lazy updates this plugin.
  -- Requires `auto_sync_herdr = true` in setup() below to take effect.
  -- build = ':lua require("herdr-splits").sync_herdr()',
  config = function()
    require('herdr-splits').setup {
      -- Defaults shown. All fields optional.
      default_amount = 0.03, -- Herdr resize ratio
      neovim_amount = 3, -- Neovim resize cells
      at_edge = 'wrap', -- 'wrap' | 'stop' | 'split' | function
      ignored_buftypes = { 'nofile', 'quickfix', 'prompt', 'help', 'terminal' },
      ignored_filetypes = {
        'NvimTree',
        -- sidebars
        'neo-tree',
        'snacks_dashboard',
        'snacks_explorer',
        'snacks_picker',
        -- DB / REPL / data sidebars
        'dadbod-ui',
        'dbout',
        -- outlines / symbols
        'aerial',
        'Outline',
        -- diagnostics / quick lists
        'Trouble',
        'quickfix',
      },
      move_cursor_same_row = false,
      herdr_bin = nil, -- auto-detected from HERDR_BIN_PATH
      floating_zindex_max = 50, -- floats with zindex < this are treated as embedded sidebars
      ignore_previewwindows = false, -- opt-in: also treat previewwindow windows (e.g. .dbout) as sidebars
      -- auto_sync_herdr = true,      -- opt-in: sync Herdr-side scripts on update
      -- Managed keys — written to the generated herdr-splits.conf so the
      -- Herdr-side scripts agree. Pass Neovim notation (e.g. <M-Left>).
      nav_keys = {
        left = '<C-h>',
        down = '<C-j>',
        up = '<C-k>',
        right = '<C-l>',
      },
      -- alt+j/k are the line-move/visual-block bindings (keymaps.lua), so
      -- resize down/up forward via alt+shift+j/k, triggered by prefix+alt+j/k.
      resize_keys = {
        left = '<M-h>',
        down = '<M-S-j>',
        up = '<M-S-k>',
        right = '<M-l>',
      },
      unzoom_on_nav = true, -- auto-unzoom when navigating away from a zoomed pane
      nav_at_edge = 'wrap', -- 'wrap' | 'stop' — Herdr pane-boundary wrap (distinct from at_edge)
    }
  end,
  keys = {
    {
      '<leader>bo',
      open_herdr_pane_with_current_buffer,
      desc = 'Open nvim in a new Herdr right pane with current buffer',
    },
    {
      '<C-h>',
      function()
        require('herdr-splits').move_cursor_left()
      end,
      desc = 'Navigate left',
    },
    {
      '<C-j>',
      function()
        require('herdr-splits').move_cursor_down()
      end,
      desc = 'Navigate down',
    },
    {
      '<C-k>',
      function()
        require('herdr-splits').move_cursor_up()
      end,
      desc = 'Navigate up',
    },
    {
      '<C-l>',
      function()
        require('herdr-splits').move_cursor_right()
      end,
      desc = 'Navigate right',
    },
    {
      '<M-h>',
      function()
        require('herdr-splits').resize_left()
      end,
      desc = 'Resize left',
    },
    {
      '<M-S-j>',
      function()
        require('herdr-splits').resize_down()
      end,
      desc = 'Resize down (triggered via prefix+alt+j in Herdr)',
    },
    {
      '<M-S-k>',
      function()
        require('herdr-splits').resize_up()
      end,
      desc = 'Resize up (triggered via prefix+alt+k in Herdr)',
    },
    {
      '<M-l>',
      function()
        require('herdr-splits').resize_right()
      end,
      desc = 'Resize right',
    },
  },
}
