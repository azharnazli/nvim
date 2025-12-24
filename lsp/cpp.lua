return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--completion-style=detailed',
    '--header-insertion=iwyu',
    '--fallback-style=Microsoft', -- used if no .clang-format in project
    '--compile-commands-dir=build',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = {
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'CMakeLists.txt',
    'Makefile',
    '.git',
  },
  workspace_required = false,
}
