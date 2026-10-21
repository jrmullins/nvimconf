# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

## Verifying changes

No tests or linter. Check a change by starting Neovim headless and looking for errors:

- `nvim --headless +qa` — loads the full config; any Lua error prints to stderr
- `nvim --headless "+Lazy! restore" +qa` — install plugins at `lazy-lock.json` commits
- `nvim --headless "+checkhealth" "+w! /tmp/health.txt" +qa` — health report (LSP, treesitter, snacks)

## Notes

- Requires Neovim 0.12+. Use the native APIs (`vim.lsp.enable`, `vim.lsp.config`, `vim.uv`), not legacy `require("lspconfig").x.setup()`.
- Non-gopls servers use nvim-lspconfig defaults; add a server by adding a `server = "binary"` entry to `servers` in `lua/lsp/init.lua` and an install target in the `Makefile`.
- Lua style: 4-space indent, double quotes.
- New setup steps belong in the `Makefile` (idempotent, macOS + Linux) and README.
