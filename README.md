# nvim config

My personal Neovim configuration, based on [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim) (itself a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)).

This is not a distribution — it's my own setup, customized for the way I work. It's organized as a multi-file config under `lua/` rather than a single `init.lua`.

## Structure

```
lua/
  keymaps.lua        # keybindings
  options.lua        # vim options
  lazy-bootstrap.lua # lazy.nvim setup
  lazy-plugins.lua   # plugin list entry point
  plugins/
    coding/          # code editing plugins
    completion/      # completion engine
    editor/          # general editor enhancements
    lsp/             # language server config
    treesitter/      # syntax/treesitter
    ui/              # appearance and UI
```

## Requirements

### System tools

| Tool | Why |
| :--- | :--- |
| `git` | lazy.nvim plugin manager |
| `make` + C compiler (`gcc`) | builds `telescope-fzf-native` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) (`rg`) | telescope file search and live grep |
| [`fd`](https://github.com/sharkdp/fd) | faster file finding |
| `node` / `npm` | TypeScript/JS LSPs, formatters, and linters (see below) |
| A [Nerd Font](https://www.nerdfonts.com/) | icons throughout the UI — set `vim.g.have_nerd_font = true` in `init.lua` |

On macOS with Homebrew:

```sh
brew install ripgrep fd node
brew install --cask font-jetbrains-mono-nerd-font  # or any Nerd Font
```

### Managed by Mason (auto-installed)

These are installed automatically via [mason.nvim](https://github.com/williamboman/mason.nvim) on first launch — no manual steps needed:

- `lua-language-server`
- `stylua` (Lua formatter)
- `ts_ls` (TypeScript/JavaScript LSP)
- `eslint`
- `vue-language-server`

### Optional / per-project

- `prettierd` or `prettier` — JS/TS formatting (if `oxfmt` is not available)
- `oxfmt` — preferred JS/TS formatter if installed
- `markdownlint` — Markdown linting (`npm install -g markdownlint-cli`)

## Installation

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

Lazy.nvim will bootstrap itself and install all plugins on first launch.
