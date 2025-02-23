vim.g.zig_fmt_parse_errors = 0
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
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    { 'j-hui/fidget.nvim', opts = {} },
  },

  -- example using `opts` for defining servers
  opts = {
    servers = {
      rust_analyzer = {
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
              extraArgs = {
                '--no-deps',
              },
            },
          },
        },
      },
      goimports = {},
      gopls = {
        formatting = {
          style = 'goimports', -- Use goimports style
          maxLineLength = 120, -- Set max line width to 120
        },
        settings = {
          gopls = {
            analyses = {
              ST1003 = true,
              fieldalignment = false,
              fillreturns = true,
              nilness = true,
              nonewvars = true,
              shadow = true,
              undeclaredname = true,
              unreachable = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            codelenses = {
              gc_details = true, -- Show a code lens toggling the display of gc's choices.
              generate = true, -- show the `go generate` lens.
              regenerate_cgo = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            buildFlags = { '-tags', 'integration' },
            completeUnimported = true,
            diagnosticsDelay = '500ms',
            gofumpt = true,
            matcher = 'Fuzzy',
            semanticTokens = true,
            staticcheck = true,
            symbolMatcher = 'fuzzy',
            usePlaceholders = true,
          },
        },
      },
      eslint = {},
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
            zls = {
              buildOnSaveStep = 'check',
            },
            buildOnSave = true,
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
      tailwindcss = {},
    },
  },

  config = function(_, opts)
    require('mason').setup()
    local ensure_installed = {
      'codespell',
      'prettierd',
      'goimports',
      'zls',
      'rust_analyzer',
      'vtsls',
      'lua-language-server',
      'gopls',
      'stylua',
      'eslint-lsp',
      'tailwindcss',
    }

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup(
        'kickstart-lsp-attach',
        { clear = true }
      ),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(
            mode,
            keys,
            func,
            { buffer = event.buf, desc = 'LSP: ' .. desc }
          )
        end
        map(
          'gd',
          require('telescope.builtin').lsp_definitions,
          'Goto Definition'
        )
        map(
          'gr',
          require('telescope.builtin').lsp_references,
          'Goto References'
        )
        map(
          'gI',
          require('telescope.builtin').lsp_implementations,
          'Goto Implementation'
        )
        map(
          'gy',
          require('telescope.builtin').lsp_type_definitions,
          'Type Definition'
        )
        map(
          '<leader>ls',
          require('telescope.builtin').lsp_document_symbols,
          'Document Symbols'
        )
        map(
          '<leader>ws',
          require('telescope.builtin').lsp_dynamic_workspace_symbols,
          'Workspace Symbols'
        )
        map('<leader>lr', vim.lsp.buf.rename, 'Rename')
        map('<leader>la', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_documentHighlight
          )
        then
          local highlight_augroup = vim.api.nvim_create_augroup(
            'kickstart-lsp-highlight',
            { clear = false }
          )
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup(
              'kickstart-lsp-detach',
              { clear = true }
            ),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds {
                group = 'kickstart-lsp-highlight',
                buffer = event2.buf,
              }
            end,
          })
        end
        if
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_inlayHint
          )
        then
          map('<leader>lh', function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
            )
          end, 'Toggle Inlay Hints')
        end
      end,
    })

    local lspconfig = require 'lspconfig'
    for server, config in pairs(opts.servers) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it
      config.capabilities =
        require('blink.cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end
  end,
}
