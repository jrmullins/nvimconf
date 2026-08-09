# nvimconf

A comprehensive Neovim configuration with Go language support, modern UI enhancements, and productivity-focused plugins.

## Prerequisites

External tools required for full functionality:

```bash
# Go language server
brew install gopls

# Protobuf/gRPC tooling (LSP, linting, formatting)
brew install buf
```

## Configuration Overview

### Current Structure
The entire configuration is currently contained in a single `init.lua` file (~333 lines) with the following sections:

1. **Lazy.nvim Bootstrap** (lines 8-16) - Plugin manager setup
2. **Plugin Specifications** (lines 21-185) - All plugin definitions and configurations
3. **General Vim Options** (lines 189-205) - Basic editor settings
4. **Language-specific Configuration** (lines 209-231) - Go-specific settings and autocmds
5. **Completion Setup** (lines 235-251) - nvim-cmp configuration
6. **LSP Configuration** (lines 255-275) - Language server setup
7. **Telescope Setup** (lines 279-281) - File finder configuration
8. **Colorscheme** (lines 285-287) - Theme settings
9. **Keymaps** (lines 292-321) - All key bindings
10. **Custom Commands** (lines 325-331) - User-defined commands

### Modularization Plan

The current monolithic `init.lua` should be split into logical modules for better maintainability:

```
lua/
├── plugins/
│   ├── init.lua           # Plugin loader (lazy.nvim setup)
│   ├── completion.lua     # nvim-cmp, luasnip
│   ├── editor.lua         # treesitter, comments, indent-blankline
│   ├── git.lua           # gitsigns, diffview
│   ├── lsp.lua           # Language server configurations
│   ├── telescope.lua     # File finder and extensions
│   ├── ui.lua            # Colorschemes, render-markdown, file tree
│   └── utils.lua         # claude-code, plenary, other utilities
├── config/
│   ├── autocmds.lua      # Auto commands (Go formatting, etc.)
│   ├── keymaps.lua       # All key bindings
│   ├── options.lua       # Vim options and settings
│   └── commands.lua      # Custom user commands
├── lang/
│   └── go.lua            # Go-specific configuration
└── init.lua              # Main entry point (loads all modules)
```

### What to Look For

When working with this configuration:

**Plugin Management:**
- All plugins use lazy.nvim for management
- Look for `dependencies` to understand plugin relationships
- Check `config` functions for plugin-specific setup
- `ft` (filetype) and `lazy` options control when plugins load

**Key Bindings:**
- Leader key is set to space (`<leader>` = ` `)
- Telescope bindings use `<leader>f` prefix
- LSP bindings use `<leader>` for actions
- File tree toggle: `<leader>ft`
- Claude Code toggle: `<leader>cc`

**Language Support:**
- Go: Full LSP support with gopls, auto-formatting with goimports
- YAML: Enhanced support with cuducos/yaml.nvim
- Treesitter: Syntax highlighting for go, lua, vim, bash, markdown, yaml

**File Organization:**
- Hidden files are shown in Telescope
- Git integration with gitsigns and diffview
- File browser available via Telescope
- NvimTree for sidebar file exploration

**Current Issues to Address:**
- Single large file makes navigation difficult
- Plugin configurations are mixed with core settings
- Language-specific code should be separated
- Keymaps are scattered throughout the file
- No clear separation of concerns