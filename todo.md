# Neovim Performance TODO

## High Priority
- [ ] Make `neogit` lazy-load only on command/key use.
  - File: `lua/custom/plugins/neogit.lua`
  - Remove startup `require('neogit')` from `init`.
  - Move setup to `config`, trigger via `cmd = { "Neogit" }` or key.

- [ ] Make `overseer` lazy-load (do not load at startup).
  - File: `lua/custom/plugins/overseer.lua`
  - Add lazy trigger (`cmd`, `keys`, or `event = "VeryLazy"`).

- [ ] Prevent DAP stack from loading at startup.
  - File: `lua/core/debug.lua`
  - Keep key-based loading only.
  - Ensure no other plugin forces DAP require on startup.

- [ ] Disable Mason auto-run on startup.
  - File: `lua/core/mason.lua`
  - Set `run_on_start = false`.

- [ ] Fix tmux startup error.
  - File: `lua/core/tmux.lua`
  - Guard `name` before `taken_names[name] = true`.
  - Skip invalid lines from `tmux list-windows`.

## Medium Priority
- [ ] Reduce Treesitter startup cost.
  - File: `lua/core/treesitter.lua`
  - Consider lazy event loading (`BufReadPost`, `BufNewFile`) for textobjects.
  - Re-evaluate `auto_install = true` if unnecessary.

- [ ] Lazy-load always-on plugins where possible.
  - Files:
    - `lua/custom/plugins/oil-nvim.lua`
    - `lua/custom/plugins/markview.lua`
    - `lua/custom/plugins/stay-centered.lua`
    - `lua/custom/plugins/persistence.lua`
  - Replace `lazy = false` with event/key/cmd triggers where practical.

- [ ] Remove duplicate FZF autocmd registration.
  - File: `lua/custom/plugins/fzf-lua.lua`
  - Keep only one `FileType = "fzf"` autocmd block.

## Runtime Smoothness
- [ ] Optimize diagnostic virtual-line toggling.
  - File: `lua/custom/plugins/lspline.lua`
  - Avoid running heavy logic on every `CursorMoved`.
  - Prefer `CursorHold` only, or debounce callback.

- [ ] Re-check FocusGained refresh behavior.
  - File: `lua/plugins.lua`
  - Measure cost of refreshing neo-tree + gitsigns every focus.
  - Consider conditional/less frequent refresh.

## Validation
- [ ] Measure startup before and after each change.
  - Command: `nvim --headless -i NONE -n --startuptime /tmp/nvim-prof/startup.log '+qall!'`
- [ ] Track target:
  - Current average: ~155ms (this config)
  - Baseline (`--clean`): ~6ms
  - Initial goal: <100ms
