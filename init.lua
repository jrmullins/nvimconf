-- ============================================================================
-- NEOVIM CONFIGURATION
-- ============================================================================

-- ============================================================================
-- LAZY.NVIM BOOTSTRAP
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGIN SPECIFICATIONS
-- ============================================================================
require("lazy").setup({
  -- Language Support
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig"
    }
  },
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua"
    },
  },

  -- Completion and Snippets
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Telescope and File Management
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      
      local open_after_tree = function(prompt_bufnr)
        vim.defer_fn(function()
          actions.select_default(prompt_bufnr)
        end, 100) -- Delay allows filetype and plugins to settle before opening
      end
      
      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
          }
        },
        defaults = {
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "venv/",
            "gen/",
          },
          mappings = {
            i = { ["<CR>"] = open_after_tree },
            n = { ["<CR>"] = open_after_tree },
          },
        },
      })
    end
  },
  "nvim-telescope/telescope-file-browser.nvim",
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "right",
          preserve_window_proportions = true,
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
        },
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "lua", "vim", "bash", "markdown", "yaml", "python", "proto" },
        highlight = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true
  },

  -- UI and Visual Enhancements
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function get_repo_name()
        local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          if result and result ~= "" then
            return vim.fn.fnamemodify(result:gsub("\n", ""), ":t")
          end
        end
        return ""
      end

      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "filename",
              path = 1  -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          },
          lualine_b = {
            {
              get_repo_name,
              icon = "",
            },
            "branch",
            "diff",
            -- "diagnostics"
          },
          lualine_c = {""}, -- "mode"
          lualine_x = {"" },--"encoding", "fileformat", "filetype" },
          lualine_y = {"filetype"},--"progress" },
          lualine_z = {"location", "progress"},--"location" }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {"branch"},
          lualine_c = { "" },
          lualine_x = {  },
          lualine_y = {},
          lualine_z = {"location"}
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ft = { "yaml", "python", "lua" },
    opts = {}
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    opts = {},
  },
  'Bekaboo/deadcolumn.nvim',
  {
      "sphamba/smear-cursor.nvim",
      opts = {
        cursor_color="#0088ff",
        stiffness = 0.3,
        trailing_stiffness = 0.1,
        trailing_exponent = 5,
        damping = 0.5,
        never_draw_over_target = true,
        hide_target_hack = true,
        gamma = 1,
      }
  },

  -- Color Schemes
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    priority = -1
  },
  { "marko-cerovac/material.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 0
  },
  {
      "rebelot/kanagawa.nvim",
      name = "kanagawa",
      priority = 0
  },

  -- Utility Plugins
  "nvim-lua/plenary.nvim",
  {
    "numToStr/Comment.nvim",
    opts = {}
  },
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        window = {
          position = "float",
          float = {
            width = "90%",
            height = "90%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "double",
          },
        },
      })
    end
  },
})

-- ============================================================================
-- GENERAL VIM OPTIONS
-- ============================================================================
vim.g.mapleader = " "

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true

-- Enable filetype detection
vim.cmd("filetype plugin indent on")

-- Set colorcolumn for deadcolumn plugin
vim.o.colorcolumn = "80"

-- ============================================================================
-- LANGUAGE-SPECIFIC CONFIGURATION
-- ============================================================================

-- Go setup
require("go").setup()

-- Go file settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 8
    vim.bo.tabstop = 8
    vim.bo.softtabstop = 8
  end,
})

-- Auto-run goimports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
})

-- ============================================================================
-- COMPLETION SETUP
-- ============================================================================
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================
-- NOTE: If you're having LSP installation/management issues, consider using Mason.nvim
-- instead. Mason provides a nice UI and automatic LSP management. Uncomment the
-- configuration below and comment out the manual LSP setup.
--
-- Mason setup (alternative approach):
--[[
{
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
  end,
},
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "mason.nvim", "nvim-lspconfig" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "gopls", "pyright", "buf_ls", "lua_ls" },
      automatic_installation = true,
    })
    
    -- Simplified LSP setup with Mason
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
      
      ["pyright"] = function()
        require("lspconfig").pyright.setup({
          capabilities = capabilities,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true
              }
            }
          }
        })
      end,
      
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        })
      end,
    })
  end,
},
--]]

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Go LSP
lspconfig.gopls.setup({
  capabilities = capabilities,
})

-- Python LSP with dynamic venv detection
local function find_python_path()
  -- Common venv locations
  local venv_patterns = {
    "./venv/bin/python",
    "./.venv/bin/python",
    "./backend/venv/bin/python",
    "./env/bin/python"
  }

  for _, path in ipairs(venv_patterns) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- Fallback to system python
  return "python3"
end

lspconfig.pyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
      pythonPath = find_python_path(),
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      }
    }
  },
  root_dir = lspconfig.util.root_pattern("pyrightconfig.json", "pyproject.toml", "setup.py", ".git")
})

-- Lua LSP
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Protobuf LSP
lspconfig.buf_ls.setup({
  capabilities = capabilities,
})

-- LSP keymaps (auto-attached when LSP server starts)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end,
})

-- ============================================================================
-- TELESCOPE SETUP
-- ============================================================================
require("telescope").load_extension("file_browser")


-- ============================================================================
-- COLORSCHEME
-- ============================================================================
vim.g.material_style = "Darker"
vim.cmd.colorscheme("tokyonight-night")
-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme("kanagawa-dragon")

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })
vim.keymap.set("n", "<leader>o", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "Git Status" })

-- LSP
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { border = "rounded", focus = false })
end, { desc = "Show Diagnostic" })

-- File Tree
vim.keymap.set("n", "<leader>ft", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Tree" })

-- Claude Code
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })

-- Navigation in Insert Mode
vim.keymap.set("i", "<A-Left>", "<C-o>b", { desc = "Move word backward" })
vim.keymap.set("i", "<A-Right>", "<C-o>w", { desc = "Move word forward" })

-- Shift Tab for Indentation
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Unindent line" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

-- jj to escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- ============================================================================
-- CUSTOM COMMANDS
-- ============================================================================

-- Go YAML Test Command
vim.api.nvim_create_user_command("GoYamlTest", function()
  local filename = vim.fn.expand("%:t")
  vim.cmd('!go test -v ./internal/functional_test -run "^TestApi$/^' .. filename .. '$"')
end, { desc = "Run Go YAML test for current file" })

-- Quit All Command
vim.api.nvim_create_user_command("QQ", function()
  vim.cmd("qall")
end, { desc = "Quit all buffers and windows" })

