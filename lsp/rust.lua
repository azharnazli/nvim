return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  workspace_required = false,

  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      inlayHints = {
        bindingModeHints = { enable = true },
        lifetimeElisionHints = {
          enable = true,
          useParameterNames = true,
        },
        closureReturnTypeHints = { enable = 'always' },
        expressionAdjustmentHints = {
          enable = true,
          hideOutsideUnsafe = false,
          mode = 'prefix',
        },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
}
