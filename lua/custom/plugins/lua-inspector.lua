return {
  'FractalCodeRicardo/lua-inspector',
  ft = { 'lua', 'luau' },
  config = function()
    require('lua-inspector').setup()
  end,
}
