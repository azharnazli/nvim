vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.omni_sql_no_default_maps = 0
vim.opt.fileformat = 'unix'
vim.opt.fileformats = 'unix,dos'

require 'options'

require 'keymaps'

require 'bootstrap'

require 'plugins'

require 'lsp'

require 'user'
