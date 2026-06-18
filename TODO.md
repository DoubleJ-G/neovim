# TODO

## Manual Steps Required

- [ ] **Clean orphaned lockfile entries.** Run `:Lazy clean` to remove `supermaven-nvim`, `data-viewer.nvim`, and `sqlite.lua`, then commit the updated `lazy-lock.json`.

## Low Priority

- [ ] **Verify Nerd Font is installed.** `init.lua` sets `vim.g.have_nerd_font = true`. If missing, icons will render as broken glyphs.
