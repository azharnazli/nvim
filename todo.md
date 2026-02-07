# Neovim Performance TODO

## High Priority
- [x] Make `neogit` lazy-load only on command/key use.
  - File: `lua/custom/plugins/neogit.lua`
  - Remove startup `require('neogit')` from `init`.
  - Move setup to `config`, trigger via `cmd = { "Neogit" }` or key.

- [x] Make `overseer` lazy-load (do not load at startup).
  - File: `lua/custom/plugins/overseer.lua`
  - Add lazy trigger (`cmd`, `keys`, or `event = "VeryLazy"`).

- [x] Prevent DAP stack from loading at startup.
  - File: `lua/core/debug.lua`
  - Keep key-based loading only.
  - Ensure no other plugin forces DAP require on startup.

- [x] Disable Mason auto-run on startup.
  - File: `lua/core/mason.lua`
  - Set `run_on_start = false`.

- [x] Fix tmux startup error.
  - File: `lua/core/tmux.lua`
  - Guard `name` before `taken_names[name] = true`.
  - Skip invalid lines from `tmux list-windows`.

## Medium Priority
- [x] Reduce Treesitter startup cost.
  - File: `lua/core/treesitter.lua`
  - Added lazy event loading (`BufReadPost`, `BufNewFile`) for treesitter and textobjects.
  - Set `auto_install = false`.

- [x] Lazy-load always-on plugins where possible.
  - Files:
    - `lua/custom/plugins/oil-nvim.lua`
    - `lua/custom/plugins/markview.lua`
    - `lua/custom/plugins/stay-centered.lua`
    - `lua/custom/plugins/persistence.lua`
  - Replace `lazy = false` with event/key/cmd triggers where practical.

- [x] Remove duplicate FZF autocmd registration.
  - File: `lua/custom/plugins/fzf-lua.lua`
  - Keep only one `FileType = "fzf"` autocmd block.

## Runtime Smoothness
- [x] Optimize diagnostic virtual-line toggling.
  - File: `lua/custom/plugins/lspline.lua`
  - Removed custom `CursorMoved` loop and switched to direct diagnostic config toggle.
  - Uses `virtual_lines = { only_current_line = true }` when enabled.

- [x] Re-check FocusGained refresh behavior.
  - File: `lua/plugins.lua`
  - Added throttling and avoids loading plugins just to refresh.
  - Refresh runs only if plugin is already loaded.

## Validation
- [x] Measure startup before and after each change.
  - Command: `nvim --headless -i NONE -n --startuptime /tmp/nvim-prof/startup.log '+qall!'`
- [x] Track target:
  - Before optimization average: `~155.637ms` (5 runs)
  - After high-priority + neogit average: `~107.342ms` (5 runs)
  - Final average: `~40.843ms` (5 runs, `XDG_CACHE_HOME=/tmp`)
  - Baseline (`--clean`): `~5.680ms` (5 runs, `XDG_CACHE_HOME=/tmp`)
  - Initial goal (`<100ms`): achieved
