return {
  'williamboman/mason.nvim',
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonUninstall',
    'MasonUpdate',
    'MasonLog',
  },
  build = ':MasonUpdate',

  dependencies = {
    'whoissethdaniel/mason-tool-installer.nvim',
  },

  config = function()
    require('mason').setup()

    require('mason-tool-installer').setup {
      ensure_installed = {
        'bash-language-server',
        'clangd',
        'eslint-lsp',
        'gopls',
        'json-lsp',
        'lua-language-server',
        'ols',
        'pyright',
        'rust-analyzer',
        'shellcheck',
        'shfmt',
        'stylua',
        'prettierd',
        'tailwindcss-language-server',
        'vtsls',
        'zls',
      },
      run_on_start = true,
      auto_update = true,
    }

    local registry_ok, registry = pcall(require, 'mason-registry')
    if not registry_ok then
      return
    end

    local ft_to_packages = {
      javascript = { 'vtsls', 'eslint-lsp' },
      javascriptreact = { 'vtsls', 'eslint-lsp' },
      typescript = { 'vtsls', 'eslint-lsp' },
      typescriptreact = { 'vtsls', 'eslint-lsp' },
      c = { 'clangd' },
      cpp = { 'clangd' },
      objc = { 'clangd' },
      objcpp = { 'clangd' },
      cuda = { 'clangd' },
      lua = { 'lua-language-server' },
      go = { 'gopls' },
      gomod = { 'gopls' },
      gowork = { 'gopls' },
      gotmpl = { 'gopls' },
      zig = { 'zls' },
      zir = { 'zls' },
      odin = { 'ols' },
      python = { 'pyright' },
      rust = { 'rust-analyzer' },
      sh = { 'bash-language-server', 'shellcheck', 'shfmt' },
      bash = { 'bash-language-server', 'shellcheck', 'shfmt' },
      zsh = { 'bash-language-server', 'shellcheck', 'shfmt' },
      json = { 'json-lsp' },
      css = { 'tailwindcss-language-server' },
      scss = { 'tailwindcss-language-server' },
      less = { 'tailwindcss-language-server' },
      html = { 'tailwindcss-language-server' },
    }

    local installing = {}
    local function ensure_package_installed(package_name)
      if installing[package_name] or not registry.has_package(package_name) then
        return
      end

      local package = registry.get_package(package_name)
      if package:is_installed() then
        return
      end

      installing[package_name] = true
      package:install()
      package:on('install:success', function()
        installing[package_name] = nil
      end)
      package:on('install:failed', function()
        installing[package_name] = nil
      end)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('mason-auto-install-by-filetype', {
        clear = true,
      }),
      callback = function(args)
        local packages = ft_to_packages[args.match]
        if not packages then
          return
        end
        for _, package_name in ipairs(packages) do
          ensure_package_installed(package_name)
        end
      end,
    })
  end,
}
