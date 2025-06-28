vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.omni_sql_no_default_maps = 0
vim.opt.fileformat = 'unix'

if vim.g.vscode then
  local vscode = require 'vscode'
  vim.notify = vscode.notify
  require 'keymap_vscode'
  require 'options_vscode'
else
  -- [[ Setting options ]]
  require 'options'

  require 'auto'
  require 'user'

  -- [[ Basic Keymaps ]]
  require 'keymaps'

  -- [[ Install `lazy.nvim` plugin manager ]]
  require 'lazy-bootstrap'

  -- [[ Configure and install plugins ]]
  require 'lazy-plugins'

  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end
