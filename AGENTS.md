# AGENTS.md

## Overview

Personal Neovim configuration (Lua) using lazy.nvim. No build step, tests, or CI.
Still learning Neovim — suggest conventions or improvements when you notice them.

## Structure

- `init.lua` — entrypoint, loads modules in strict order (see below)
- `lua/config/` — options, keymaps, autocmds, commands, colors
- `lua/plugins/` — lazy.nvim plugin specs split into: lang, snacks, ui, tools, git
- `lua/lsp/` — LSP config (buf_ls for protobuf) and LspAttach keymaps
- `lazy-lock.json` — plugin lockfile (commit after plugin changes)
- `Makefile` — LSP server installation helpers (`make lsp`, `make check-deps`)
- `bak_lua/` — backup/legacy files, do not edit

## Load order (init.lua)

Options → Plugins → Autocmds → Keymaps → Commands → LSP → Colors.
New modules must be `require()`d in `init.lua` to take effect.

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
- buf_ls (protobuf): configured in `lua/lsp/init.lua` using `vim.lsp.config` + `vim.lsp.enable`
- Other servers: install via `make lsp` (gopls, pyright, bufls, lua-language-server, ruby-lsp)

## Go development

- go.nvim handles gopls setup, goimports on save, and Go tooling
- Treesitter ensured languages: go, lua, markdown, proto

## Plugin conventions

- Prefer folke plugins (snacks.nvim, which-key.nvim, trouble.nvim, lazy.nvim) before considering alternatives from other authors
- All plugins defined as lazy.nvim spec tables returned from modules
- To add plugins: create or extend a file in `lua/plugins/`, add its module name to the `modules` list in `lua/plugins/init.lua`
- `lazy-lock.json` tracks pinned commits — run `:Lazy update` then commit the lockfile

## Snacks.nvim

Primary UI framework. Key pickers: `<leader>ff` (files), `<leader>fg` (grep), `<leader>ft` (explorer), `<leader>gs` (git status). Explorer replaces netrw. Explorer keybindings: `a` (add file/dir), `d` (delete), `r` (rename), `m` (move), `c` (copy), `<Tab>` (select multiple).

## which-key.nvim

Keybinding discovery popup — press `<leader>` and wait to see all mappings. `<leader>?` shows buffer-local keymaps. Vim builtin help for `d`, `y`, `g`, `z`, `<c-w>` also available.

## README.md

Outdated — describes a monolithic init.lua that no longer exists. Do not trust for structure info.
