return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    'saghen/blink.cmp',
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim', lazy = true },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'dmmulroy/ts-error-translator.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
  },

  opts = {
    servers = {
      clangd = {
        capabilities = {
          offsetEncoding = 'utf-8',
        },
      },
      jsonls = {
        filetypes = { 'json', 'jsonc' },
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { 'package.json' },
                url = 'https://json.schemastore.org/package.json',
              },
              {
                fileMatch = { 'tsconfig*.json' },
                url = 'https://json.schemastore.org/tsconfig.json',
              },
              {
                fileMatch = {
                  '.prettierrc',
                  '.prettierrc.json',
                  'prettier.config.json',
                },
                url = 'https://json.schemastore.org/prettierrc.json',
              },
              {
                fileMatch = { '.eslintrc', '.eslintrc.json' },
                url = 'https://json.schemastore.org/eslintrc.json',
              },
              {
                fileMatch = { '.babelrc', '.babelrc.json', 'babel.config.json' },
                url = 'https://json.schemastore.org/babelrc.json',
              },
              {
                fileMatch = { 'lerna.json' },
                url = 'https://json.schemastore.org/lerna.json',
              },
              {
                fileMatch = { 'now.json', 'vercel.json' },
                url = 'https://json.schemastore.org/now.json',
              },
              {
                fileMatch = {
                  '.stylelintrc',
                  '.stylelintrc.json',
                  'stylelint.config.json',
                },
                url = 'https://json.schemastore.org/stylelintrc.json',
              },
            },
          },
        },
      },
      gopls = {},
      vtsls = {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            inlayHints = {
              parameterNames = { enabled = 'all' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = 'always' },
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          vtsls = {
            enableMoveToFileCodeAction = true,
          },
        },
      },
      zls = {
        settings = {
          zig = {
            zls = { buildOnSaveStep = 'check' },
            buildOnSave = true,
          },
        },
      },

      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },

      tailwindcss = {},
      -- eslint = {},
    },
  },

  config = function(_, opts)
    -- Mason & tool installation
    require('mason').setup()

    local ensure_installed = {
      'jsonls',
      'codespell',
      'prettier',
      'goimports',
      'vtsls',
      'lua-language-server',
      'gopls',
      'stylua',
      'eslint_d',
      'biome',
      'tailwindcss',
    }

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    ---------------------------------------------------------------------------
    -- LSP attach helpers
    ---------------------------------------------------------------------------
    local function map(buf, mode, lhs, rhs, desc)
      mode = mode or 'n'
      vim.keymap.set(
        mode,
        lhs,
        rhs,
        { buffer = buf, desc = ('LSP: %s'):format(desc or '') }
      )
    end

    local function setup_keymaps(buf)
      local tb = require 'telescope.builtin'
      map(buf, 'n', 'gd', tb.lsp_definitions, 'Goto Definition')
      map(buf, 'n', 'gr', tb.lsp_references, 'Goto References')
      map(buf, 'n', 'gI', tb.lsp_implementations, 'Goto Implementation')
      map(buf, 'n', 'gy', tb.lsp_type_definitions, 'Type Definition')
      map(buf, 'n', '<leader>ls', tb.lsp_document_symbols, 'Document Symbols')
      map(
        buf,
        'n',
        '<leader>ws',
        tb.lsp_dynamic_workspace_symbols,
        'Workspace Symbols'
      )
      map(buf, 'n', '<leader>lr', vim.lsp.buf.rename, 'Rename')
      map(
        buf,
        { 'n', 'x' },
        '<leader>la',
        vim.lsp.buf.code_action,
        'Code Action'
      )
      map(buf, 'n', 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
    end

    local function setup_highlighting(client, buf)
      if
        not (
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_documentHighlight
          )
        )
      then
        return
      end
      local group = vim.api.nvim_create_augroup(
        'kickstart-lsp-highlight',
        { clear = false }
      )

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        buffer = buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = group,
        buffer = buf,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup(
          'kickstart-lsp-detach',
          { clear = true }
        ),
        callback = function(ev)
          pcall(vim.lsp.buf.clear_references)
          vim.api.nvim_clear_autocmds {
            group = 'kickstart-lsp-highlight',
            buffer = ev.buf,
          }
        end,
      })
    end

    local function setup_inlay_toggle(client, buf)
      if
        not (
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_inlayHint
          )
        )
      then
        return
      end

      -- Inlay hint compatibility wrapper (pre/post 0.10)
      local function toggle_inlay()
        local ih = vim.lsp.inlay_hint
        local enabled = false
        if ih and ih.is_enabled then
          enabled = ih.is_enabled { bufnr = buf }
          ih.enable(not enabled, { bufnr = buf })
        elseif ih and ih.enable and ih.get then
          enabled = ih.get(buf)
          ih.enable(buf, not enabled)
        end
      end

      map(buf, 'n', '<leader>lh', toggle_inlay, 'Toggle Inlay Hints')
    end

    local function setup_ts_error_translator(client)
      if not client then
        return
      end
      if client.name == 'vtsls' then
        local translator = require 'ts-error-translator'
        local orig = vim.lsp.handlers['textDocument/publishDiagnostics']
        vim.lsp.handlers['textDocument/publishDiagnostics'] = function(
          err,
          result,
          ctx,
          cfg
        )
          translator.translate_diagnostics(err, result, ctx)
          if orig then
            return orig(err, result, ctx, cfg)
          else
            -- Fallback (older API)
            return vim.lsp.diagnostic.on_publish_diagnostics(
              err,
              result,
              ctx,
              cfg
            )
          end
        end
      end
    end

    -- One LspAttach to rule them all
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup(
        'kickstart-lsp-attach',
        { clear = true }
      ),
      callback = function(ev)
        local buf = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        setup_keymaps(buf)
        setup_highlighting(client, buf)
        setup_inlay_toggle(client, buf)
        setup_ts_error_translator(client)
      end,
    })

    ---------------------------------------------------------------------------
    -- Server setup
    ---------------------------------------------------------------------------
    local lspconfig = require 'lspconfig'
    for server, cfg in pairs(opts.servers or {}) do
      -- Merge blink.cmp capabilities with any per-server capabilities
      cfg.capabilities =
        require('blink.cmp').get_lsp_capabilities(cfg.capabilities)
      lspconfig[server].setup(cfg)
    end
  end,
}
