if vim.fn.has 'win32' == 1 then
  vim.cmd [[
        let &shell = 'pwsh'
        let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
        let &shellquote = ''
        let &shellxquote = ''
        let &shellpipe = '|'
        let &shellredir = '2>&1 | Out-File -Encoding UTF8'
    ]]
end
return {
  'akinsho/toggleterm.nvim',
  opts = {
    size = 20,
    -- open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    direction = 'float',
    close_on_exit = true,
    clear_env = false,
    shell = vim.o.shell,
    float_opts = {
      title_pos = 'center',
      border = 'curved',
    },
    winbar = {
      enabled = false,
    },
  },
}
