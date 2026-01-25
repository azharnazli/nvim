vim.opt.number = true
vim.opt.laststatus = 3
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.fileencoding = 'utf-8'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.swapfile = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.isfname:append '@-@'
vim.opt.updatetime = 300
vim.opt.pumheight = 10
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.fileformat = 'unix'

-- Force Neovim to use wl-copy/paste directly
-- This bypasses the checkhealth detection which fails inside Tmux
vim.g.clipboard = {
  name = 'WlClipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy',
  },
  paste = {
    ['+'] = 'wl-paste',
    ['*'] = 'wl-paste',
  },
  cache_enabled = 1,
}

-- Ensure the option is set
vim.opt.clipboard = 'unnamedplus'
