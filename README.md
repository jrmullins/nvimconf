# nvimconf

Personal Neovim configuration. Lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

Focus is Go and Protobuf/gRPC development, with Ruby as a secondary language.

## New machine setup

macOS or Linux:

```sh
git clone <this repo> ~/.config/nvim
cd ~/.config/nvim
make
```

`make` is safe to re-run. In order, it:

1. checks for git, curl, tar, make and a C compiler. These can't be installed
   portably, so it prints the command to run instead (`xcode-select --install` /
   `apt install build-essential ...`);
2. installs [mise](https://mise.jdx.dev) if it is missing;
3. installs Neovim 0.12+, Go, Node, Ruby, ripgrep and the tree-sitter CLI via
   `mise use -g`, **skipping anything already on `PATH`** (e.g. from Homebrew);
4. installs the LSP servers (see below);
5. installs plugins at their `lazy-lock.json` commits, runs their build steps, and
   installs the treesitter parsers.

Afterwards, activate mise in your shell if you haven't already (see below).

### mise

Runtimes are managed by mise. Global tools live in `~/.config/mise/config.toml`:

```toml
[tools]
ruby = "latest"
node = "latest"
npm = "latest"
buf = "latest"
"npm:yaml-language-server" = "latest"
```

Per-project `mise.toml` files override this, so a project can pin its own versions
without disturbing the global setup. This repo has its own `mise.toml` with the same
three tools.

mise is activated from `.zshrc`:

```sh
eval "$(~/.local/bin/mise activate zsh)"
```

### LSP servers

Servers are installed by `make` (or just `make lsp`):

```sh
make lsp          # everything below
make lsp-go       # gopls via `go install` (go.nvim also installs it via its build step)
make lsp-proto    # buf CLI, via mise
make lsp-lua      # lua-language-server, via mise (skipped if already on PATH)
make lsp-ruby     # ruby-lsp gem, into the mise-managed ruby
make lsp-yaml     # yaml-language-server, via mise's npm backend
```

`ruby-lsp` is a plain `gem install` because mise's `gem:` backend resolves "latest" to
beta releases. It lives inside the current mise Ruby, so re-run `make lsp-ruby` after
mise upgrades Ruby. `yaml-language-server` is a mise tool, so it survives Node upgrades.

| Language | Server | Configured in |
| --- | --- | --- |
| Go | `gopls` | go.nvim (`lua/plugins/lang.lua`), goimports on save |
| Protobuf | `buf lsp serve` (`buf_ls`) | `lua/lsp/init.lua`, nvim-lspconfig defaults, format on save |
| Lua | `lua-language-server` (`lua_ls`) | `lua/lsp/init.lua` + lazydev.nvim for Neovim API types |
| Ruby | `ruby-lsp` | `lua/lsp/init.lua` |
| YAML | `yaml-language-server` (`yamlls`) | `lua/lsp/init.lua`; key hierarchy for `<leader>o` |

Servers in `lua/lsp/init.lua` are only enabled when their binary is on `PATH`, so a
missing one degrades quietly instead of erroring.

Protobuf uses the Buf CLI, the same tool used for `buf generate` / `buf lint` in gRPC
repos. It reads the project's `buf.yaml`, so lint rules and formatting match CI.

## Layout

```
init.lua              entrypoint; loads modules in a fixed order
lua/config/           options, lazy.nvim bootstrap, global keymaps
lua/plugins/          lazy.nvim specs, one file per concern (auto-imported)
lua/lsp/              LSP server list and LspAttach keymaps
```

Load order in `init.lua` is options → lazy.nvim → keymaps → lsp. Options go first so
the leader key is set before plugins register mappings. The colorscheme is applied by
the tokyonight spec in `lua/plugins/ui.lua`.

Plugins are split by concern in `lua/plugins/`: `completion`, `lang`, `snacks`, `ui`,
`tools`, `git`. `lua/config/lazy.lua` imports the whole directory, so adding a plugin
is just a matter of adding a spec to one of those files (or a new file).

## Treesitter

nvim-treesitter is on the `main` rewrite, so it uses the new install API rather than
`ensure_installed`:

```lua
require("nvim-treesitter").install({ "go", "lua", "markdown", "markdown_inline", "proto", "python", "yaml" }):wait(300000)
```

The parser list lives once, in the nvim-treesitter spec in `lua/plugins/lang.lua`. The
same `config` function installs the parsers and creates the `FileType` autocmd that
starts highlighting for them, so adding a language is a one-word change.
Parsers land in `~/.local/share/nvim/site/parser/`.

## Symbols

`<leader>o` picks a source based on what the buffer supports:

- LSP server advertising `textDocument/documentSymbol` → `lsp_symbols`
- otherwise, a Treesitter `locals` query → `treesitter`
- neither → a notification, rather than an empty list

Proto, Lua and YAML take the LSP path (`buf lsp serve`, `lua_ls`, `yamlls`). Markdown has neither, so it
gets the notification.

## Keymaps

Leader is `<Space>`. Mappings live in three places, and the distinction matters:

| Location | Scope |
| --- | --- |
| `lua/config/keymaps.lua` | global, no plugin dependency |
| plugin `keys = {}` tables | plugin-scoped, required for lazy-loading |
| `LspAttach` in `lua/lsp/init.lua` | LSP buffer-local only |

Moving a plugin keymap out of its `keys = {}` table breaks lazy-loading, so check all
three before adding a binding.

Common ones:

| Key | Action |
| --- | --- |
| `<leader>ff` / `fg` / `ft` | files / grep / explorer |
| `<leader>gs` | git status (changed files) |
| `]h` / `[h` | next / previous git hunk |
| `<leader>gp` / `gb` / `gu` | preview hunk / blame line / undo hunk |
| `<leader>o` | document symbols |
| `gr` | LSP references (Snacks picker) |
| `gd` / `K` | definition / hover |
| `<leader>n` | new file |
| `<leader>?` | buffer-local keymaps |

Press `<leader>` and wait for which-key to list the rest.

### Picker and explorer cheat sheet

Inside any Snacks picker (files, grep, explorer, ...) press `?` for its full keymap.
Handy ones:

| Key | Where | Action |
| --- | --- | --- |
| `<A-h>` / `<A-i>` | files, grep | toggle hidden / gitignored files |
| `H` / `I` | explorer | toggle hidden / gitignored files |
| `a` `d` `r` `m` `c` | explorer | add / delete / rename / move / copy |
| `<Tab>` | any | select multiple |

The files picker and explorer show hidden and gitignored files by default; `vendor/` and `node_modules/` are
always excluded (see the top of `lua/plugins/snacks.lua`).

## Git

gitsigns highlights added and changed lines across the full width (toggle with `<leader>gh`)
and draws bars in the sign column for added, changed and deleted
lines. The Snacks explorer marks changed files, and `<leader>gs` lists them.

## Dependencies

After changing plugins, run `:Lazy update` and commit `lazy-lock.json`.
