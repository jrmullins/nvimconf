.PHONY: install system-deps mise tools lsp lsp-go lsp-proto lsp-lua lsp-ruby lsp-yaml plugins help
.DEFAULT_GOAL := install

# Set up a fresh macOS or Linux machine: `make`. Safe to re-run; tools already
# on PATH (e.g. from Homebrew) are left alone, everything else comes from mise.

# mise's shims let freshly installed tools run without shell activation, and
# go.nvim installs its Go binaries into ~/go/bin.
export PATH := $(HOME)/.local/bin:$(HOME)/.local/share/mise/shims:$(HOME)/go/bin:$(PATH)

# Install $(2) with mise unless command $(1) is already on PATH.
define ensure
@if command -v $(1) >/dev/null 2>&1; then \
	echo "✅ $(1) ($$(command -v $(1)))"; \
else \
	echo "📦 Installing $(2) via mise..." && mise use -g $(2)@latest; \
fi
endef

help:
	@echo "Available targets:"
	@echo "  install     - (default) Everything below, in order"
	@echo "  system-deps - Check git, curl, tar, make and a C compiler (can't be installed portably)"
	@echo "  mise        - Install mise if missing"
	@echo "  tools       - Neovim, Go, Node, Ruby, ripgrep, tree-sitter CLI (skipped if on PATH)"
	@echo "  lsp         - All LSP servers (lsp-go, lsp-proto, lsp-lua, lsp-ruby, lsp-yaml)"
	@echo "  plugins     - Install plugins at lazy-lock.json versions, plus treesitter parsers"

install: system-deps mise tools lsp plugins
	@echo "✅ Done."
	@command -v mise >/dev/null 2>&1 && mise doctor >/dev/null 2>&1 || \
		echo '👉 Add mise to your shell, e.g. in ~/.zshrc: eval "$$(~/.local/bin/mise activate zsh)"'

system-deps:
	@echo "🔍 Checking system dependencies..."
	@missing=""; for t in git curl tar make cc; do command -v $$t >/dev/null 2>&1 || missing="$$missing $$t"; done; \
	if [ -n "$$missing" ]; then \
		echo "❌ Missing:$$missing"; \
		if [ "$$(uname)" = "Darwin" ]; then echo "   Run: xcode-select --install"; \
		else echo "   Run e.g.: sudo apt install build-essential git curl tar"; fi; \
		exit 1; \
	fi
	@echo "✅ System dependencies present"

mise:
	@if command -v mise >/dev/null 2>&1; then \
		echo "✅ mise ($$(command -v mise))"; \
	else \
		echo "📦 Installing mise (https://mise.jdx.dev)..." && curl -fsSL https://mise.run | sh; \
	fi

tools: mise
	$(call ensure,nvim,neovim)
	@nvim --version | head -1 | grep -qE 'v0\.(1[2-9]|[2-9][0-9])\.|v[1-9]' || \
		echo "⚠️  $$(nvim --version | head -1) found; this config needs 0.12+ (mise use -g neovim@latest)"
	$(call ensure,go,go)
	$(call ensure,node,node)
	$(call ensure,ruby,ruby)
	$(call ensure,rg,ripgrep)
	$(call ensure,tree-sitter,tree-sitter)

lsp: lsp-go lsp-proto lsp-lua lsp-ruby lsp-yaml
	@echo "✅ All LSP servers installed"

# go.nvim also installs gopls (and goimports etc.) when the plugin is built.
lsp-go:
	@if command -v gopls >/dev/null 2>&1; then \
		echo "✅ gopls ($$(command -v gopls))"; \
	else \
		echo "📦 Installing gopls..." && go install golang.org/x/tools/gopls@latest; \
	fi

# Buf CLI: `buf lsp serve` for protobuf, plus formatting and lint.
lsp-proto:
	$(call ensure,buf,buf)

lsp-lua:
	$(call ensure,lua-language-server,lua-language-server)

# A plain gem install, because mise's gem: backend resolves "latest" to beta
# releases. It lives inside the current mise Ruby, so re-run `make lsp-ruby`
# after mise upgrades Ruby.
lsp-ruby:
	@if command -v ruby-lsp >/dev/null 2>&1; then \
		echo "✅ ruby-lsp ($$(command -v ruby-lsp))"; \
	else \
		echo "📦 Installing ruby-lsp..." && gem install ruby-lsp; \
	fi

# A mise tool rather than `npm install -g`, so it survives mise upgrading Node.
lsp-yaml:
	@echo "📦 Installing yaml-language-server via mise..."
	@mise use -g npm:yaml-language-server@latest

# Lazy! restore installs every plugin at its lazy-lock.json commit and runs build
# steps (go.nvim binaries, LuaSnip jsregexp). Starting nvim also runs the
# nvim-treesitter config, which installs the parsers.
plugins:
	@echo "📦 Installing plugins and treesitter parsers..."
	@nvim --headless "+Lazy! restore" +qa
	@nvim --headless +qa
	@echo "✅ Plugins installed"
