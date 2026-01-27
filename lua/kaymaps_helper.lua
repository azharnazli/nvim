local m = {}
local function reload_config()
  local namespace = 'user' -- e.g. lua/user/*.lua

  for name, _ in pairs(package.loaded) do
    if name:match('^' .. namespace) then
      package.loaded[name] = nil
    end
  end

  local init = vim.fn.stdpath 'config' .. '/init.lua'
  dofile(init)

  vim.notify('Neovim config reloaded!', vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local ok, wk_title = pcall(require, 'wk_title')
    if ok then
      wk_title.register_titles()
    end
  end,
})

m.reload_config = reload_config

return m
