local oil_first = true

local function normalize_path(path)
  return vim.fs.normalize(path):gsub('\\', '/')
end

local function close_buffers_for_delete(action)
  local util = require 'oil.util'
  local fs = require 'oil.fs'
  local scheme, path = util.parse_url(action.url)

  if scheme ~= 'oil://' or not path then
    return
  end

  local target = normalize_path(fs.posix_to_os_path(util.url_unescape(path)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local buffer_path = normalize_path(vim.api.nvim_buf_get_name(bufnr))
      local is_target = buffer_path == target
      local is_child = action.entry_type == 'directory'
        and buffer_path:sub(1, #target + 1) == target .. '/'

      if is_target or is_child then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end
end

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('user-oil-actions', { clear = true }),
  pattern = 'OilActionsPre',
  callback = function(args)
    for _, action in ipairs(args.data.actions or {}) do
      if action.type == 'delete' then
        close_buffers_for_delete(action)
      end
    end
  end,
})

local function close_oil()
  local oil = require 'oil'

  if vim.bo.modified then
    local choice = vim.fn.confirm('Save changes?', '&Yes\n&No', 2)
    if choice == 1 then
      oil.save({}, function(err)
        if not err then
          oil.close()
        end
      end)
      return
    end
  end

  oil.discard_all_changes()
  oil.close()
end

return {
  'stevearc/oil.nvim',
  lazy = false,
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = { 'icon' },
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    keymaps = {
      ['q'] = close_oil,
      ['<ESC>'] = close_oil,
      ['<BS>'] = 'actions.parent',
      ['<Tab>'] = 'actions.select',
      ['.'] = { 'actions.toggle_hidden', mode = 'n' },
    },
    confirmation = {
      border = 'none',
    },
    progress = {
      max_height = { 10, 0.9 },
    },
  },
  keys = {
    {
      '<leader>e',
      function()
        if oil_first then
          oil_first = false
          vim.cmd 'Oil .'
        else
          vim.cmd 'Oil'
        end
      end,
      desc = 'Open parent directory',
    },
  },
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
}
