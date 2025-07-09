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

local win32yank_path = vim.fn.stdpath 'config' .. '/win32yank.exe'
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  once = true,
  callback = function()
    if vim.fn.has 'win32' and vim.fn.has 'wsl' == 0 then
      vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
          ['+'] = win32yank_path .. ' -i --crlf',
          ['*'] = win32yank_path .. ' -i --crlf',
        },
        paste = {
          ['+'] = win32yank_path .. ' -o --lf',
          ['*'] = win32yank_path .. ' -o --lf',
        },
      }
    elseif vim.fn.has 'wsl' == 1 then
      if vim.fn.executable 'xclip' == 1 then
        vim.g.clipboard = {
          copy = {
            ['+'] = 'xclip -selection clipboard',
            ['*'] = 'xclip -selection clipboard',
          },
          paste = {
            ['+'] = 'xclip -selection clipboard -o',
            ['*'] = 'xclip -selection clipboard -o',
          },
        }
      end
    elseif vim.fn.has 'unix' == 1 then
      if vim.fn.executable 'xclip' == 1 then
        vim.g.clipboard = {
          copy = {
            ['+'] = 'xclip -selection clipboard',
            ['*'] = 'xclip -selection clipboard',
          },
          paste = {
            ['+'] = 'xclip -selection clipboard -o',
            ['*'] = 'xclip -selection clipboard -o',
          },
        }
      elseif vim.fn.executable 'xsel' == 1 then
        vim.g.clipboard = {
          copy = {
            ['+'] = 'xsel --clipboard --input',
            ['*'] = 'xsel --clipboard --input',
          },
          paste = {
            ['+'] = 'xsel --clipboard --output',
            ['*'] = 'xsel --clipboard --output',
          },
        }
      end

      print 'please install xclip or xsel'
    end

    vim.opt.clipboard = 'unnamedplus'
  end,
  desc = 'Lazy load clipboard',
})
