return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },

  -- gopls does not require a workspace file
  workspace_required = false,

  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unreachable = true,
        nilness = true,
        unusedwrite = true,
        fillreturns = true,
        loopclosure = true,
      },
      staticcheck = true,

      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
