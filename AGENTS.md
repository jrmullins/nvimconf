# AGENTS.md

## Overview

Personal Neovim configuration (Lua) using lazy.nvim. No build step, tests, or CI.
Still learning Neovim — suggest conventions or improvements when you notice them.

## Structure

- `init.lua` — entrypoint, loads modules in strict order (see below)
- `lua/config/` — options, lazy (lazy.nvim bootstrap), keymaps
- `lua/plugins/` — lazy.nvim plugin specs, one file per concern: completion, lang, snacks, ui, tools, git
- `lua/lsp/` — LSP server list and LspAttach keymaps
- `lazy-lock.json` — plugin lockfile (commit after plugin changes)
- `Makefile` — new-machine setup for macOS/Linux: `make` installs mise, tools, LSP servers, plugins and parsers (idempotent)

## Load order (init.lua)

Options → lazy.nvim (`config.lazy`) → Keymaps → LSP.
Options come first so the leader key is set before plugins register keymaps.
New modules outside `lua/plugins/` must be `require()`d in `init.lua` to take effect.
The colorscheme is applied in the tokyonight spec's `config` in `lua/plugins/ui.lua`.

## Keybindings

Leader is `<Space>`. Keybindings live in three places, each with a distinct purpose:
1. `lua/config/keymaps.lua` — global keymaps (works everywhere, no plugin dependency)
2. Plugin `keys = {}` tables in `lua/plugins/*.lua` — plugin-scoped keymaps (required for lazy.nvim lazy-load; moving them out breaks lazy-loading)
3. `lua/lsp/init.lua` LspAttach autocmd — LSP buffer-local keymaps (only active when a language server is attached)

When adding keymaps:
- Global shortcuts → `lua/config/keymaps.lua`
- Plugin keybindings → keep in the plugin's `keys = {}` table
- LSP-only bindings → `lua/lsp/init.lua` LspAttach callback
- Check all three locations for conflicts before adding

## LSP

- gopls: managed by go.nvim plugin in `lua/plugins/lang.lua`
- buf_ls, lua_ls, ruby_lsp, yamlls: listed in the `servers` table in `lua/lsp/init.lua`, each enabled only if its binary is on PATH
- Install servers via `make lsp` (gopls, buf via mise, lua-language-server, ruby-lsp, yaml-language-server)

## Go development

- go.nvim handles gopls setup, goimports on save, and Go tooling
- Treesitter languages: single list in the nvim-treesitter spec in `lua/plugins/lang.lua` (installs parsers and starts highlighting)

## Plugin conventions

- Prefer folke plugins (snacks.nvim, which-key.nvim, trouble.nvim, lazy.nvim) before considering alternatives from other authors
- All plugins defined as lazy.nvim spec tables returned from modules
- To add plugins: create or extend a file in `lua/plugins/`. `lua/config/lazy.lua` uses `{ import = "plugins" }`, so every file there is loaded automatically
- `lazy-lock.json` tracks pinned commits — run `:Lazy update` then commit the lockfile

## Snacks.nvim

Primary UI framework. Key pickers: `<leader>ff` (files), `<leader>fg` (grep), `<leader>ft` (explorer), `<leader>gs` (git status). Explorer replaces netrw. Files picker and explorer show hidden + gitignored files but exclude `vendor`/`node_modules` (shared `file_filter` in `lua/plugins/snacks.lua`). Press `?` inside any picker for its keymap.

## which-key.nvim

Keybinding discovery popup — press `<leader>` and wait to see all mappings. `<leader>?` shows buffer-local keymaps. Default config only; picker key help comes from Snacks' own `?`.

## Custom commands

- `<leader>n` — New file. Prompts for path with tab completion, expands `~`, shows resolved absolute path for confirmation, creates parent directories automatically.

## README.md

User-facing docs (requirements, LSP setup, keymaps). Keep it in sync when changing structure, LSP servers, or common keymaps.
