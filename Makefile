.PHONY: lsp lsp-go lsp-python lsp-proto lsp-lua lsp-ruby check-deps help

# Default target
help:
	@echo "Available targets:"
	@echo "  lsp        - Install all LSP servers"
	@echo "  lsp-go     - Install Go LSP (gopls)"
	@echo "  lsp-python - Install Python LSP (pyright)"
	@echo "  lsp-proto  - Install Protobuf LSP (bufls)"
	@echo "  lsp-lua    - Install Lua LSP (lua-language-server)"
	@echo "  check-deps - Check if required dependencies are installed"

# Install all LSP servers
lsp: check-deps lsp-go lsp-python lsp-proto lsp-lua lsp-ruby
	@echo "✅ All LSP servers installed successfully!"

# Check if required dependencies are available
check-deps:
	@echo "🔍 Checking dependencies..."
	@which go >/dev/null 2>&1 || (echo "❌ Go not found. Please install Go first." && exit 1)
	@which npm >/dev/null 2>&1 || (echo "❌ npm not found. Please install Node.js/npm first." && exit 1)
	@echo "✅ Dependencies check passed"

# Install Go LSP server
lsp-go:
	@echo "📦 Installing gopls (Go LSP)..."
	@if command -v gopls >/dev/null 2>&1; then \
		echo "✅ gopls already installed ($(shell gopls version 2>/dev/null || echo 'version unknown'))"; \
	else \
		go install golang.org/x/tools/gopls@latest && \
		echo "✅ gopls installed successfully"; \
	fi

# Install Python LSP server
lsp-python:
	@echo "📦 Installing pyright (Python LSP)..."
	@if npm list -g pyright >/dev/null 2>&1; then \
		echo "✅ pyright already installed ($(shell pyright --version 2>/dev/null || echo 'version unknown'))"; \
	else \
		npm install -g pyright && \
		echo "✅ pyright installed successfully"; \
	fi

# Install Protobuf LSP server
lsp-proto:
	@echo "📦 Installing bufls (Protobuf LSP)..."
	@if command -v bufls >/dev/null 2>&1; then \
		echo "✅ bufls already installed"; \
	else \
		go install github.com/bufbuild/buf-language-server/cmd/bufls@latest && \
		echo "✅ bufls installed successfully"; \
	fi

# Install Lua LSP server
lsp-lua:
	@echo "📦 Installing lua-language-server (Lua LSP)..."
	@if command -v lua-language-server >/dev/null 2>&1; then \
		echo "✅ lua-language-server already installed"; \
	else \
		echo "Installing lua-language-server via Homebrew..."; \
		brew install lua-language-server && \
		echo "✅ lua-language-server installed successfully"; \
	fi
lsp-ruby:
	gem install ruby-lsp
