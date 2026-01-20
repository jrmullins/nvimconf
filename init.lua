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
        },
        opts = {
            lsp_keymaps = false,
            -- other options
        },
        config = function(lp, opts)
            require("go").setup(opts)
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimports()
                end,
                group = format_sync_grp,
            })
            local gopls_cfg = require("go.lsp").config()
            vim.lsp.config("gopls", gopls_cfg)
            vim.lsp.enable("gopls")
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()'
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

    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
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
                        find_command = {"rg", "--files", "--sortr=modified"},
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

    {
        'stevearc/aerial.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
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
                ensure_installed = { "go", "lua", "vim", "bash", "markdown", "yaml", "python", "proto", "sql","ruby" },
                highlight = { enable = true },
                ident = { enable = true },
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

    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        opts = {
            enabled = true,
            message_template = " <author> • <date> • <summary> • <sha>",
            date_format = "%m-%Y",
            virtual_text_column = 1,
        },
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
                            path = 1,  -- 0 = just filename, 1 = relative path, 2 = absolute path
                            file_status = true,
                            symbols = {
                                -- modified = "[ಠ_ಠ]",
                            },
                            color = function(section)
                                return { bg = vim.bo.modified and '#ccff00' }
                            end,
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
                    -- lualine_c = { { git_blame.get_current_blame.text, cond=git_blame.is_blame_text_available } }, -- "mode"
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
            hide_target_hack = true,
            gamma = 1,
        }
    },

    {
        "shortcuts/no-neck-pain.nvim",
        version = "*"
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

    {
        "KijitoraFinch/nanode.nvim",
        priority = 1000,
        config = function()
            require("nanode").setup({
                transparent = false,
            })
            vim.cmd.colorscheme("nanode")
        end,
    },

    -- Utility Plugins
    "nvim-lua/plenary.nvim",
    {
        "numToStr/Comment.nvim",
        opts = {}
    },

    {
        "folke/snacks.nvim",
        opts = {
            input = { enabled = true },
            picker = { enabled = true }
        }
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

    {
        "folke/trouble.nvim",
        opts = {
            modes = {
                diagnostics = {
                    win = {
                        position = "bottom",
                        size = { height = 15 },
                        border = "rounded",
                    },
                },
                symbols = {
                    win = {
                        position = "right",
                        size = { width = 40 },
                        border = "rounded",
                    },
                },
            },
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    }
})

-- ============================================================================
-- GENERAL VIM OPTIONS
-- ============================================================================
vim.g.mapleader = " "

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Command line height and behavior
vim.o.cmdheight = 2
vim.o.showcmd = true
vim.o.showmode = true

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
-- TREESITTER FOLDING
-- ============================================================================
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

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
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        require("mason-lspconfig").setup({
            ensure_installed = { "gopls", "pyright", "buf_ls", "lua_ls" },
            automatic_installation = true,
        })

        -- Simplified LSP setup with Mason
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                })
                vim.lsp.enable(server_name)
            end,

            ["pyright"] = function()
                vim.lsp.config("pyright", {
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
                vim.lsp.enable("pyright")
            end,

            ["lua_ls"] = function()
                vim.lsp.config("lua_ls", {
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
                vim.lsp.enable("lua_ls")
            end,
        })
    end,
},
--]]

local util = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
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

vim.lsp.config("pyright", {
    settings = {
        python = {
            pythonPath = find_python_path(),
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true
            }
        }
    },
    root_dir = util.root_pattern("pyrightconfig.json", "pyproject.toml", "setup.py", ".git")
})

-- Lua LSP
vim.lsp.config("lua_ls", {
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

local function buf_cmd()
    local default_cmd = { "buf", "lsp", "serve", "--log-format=text" }
    if vim.fn.executable("buf") == 0 then
        return default_cmd
    end

    vim.fn.system({ "buf", "lsp", "--help" })
    if vim.v.shell_error == 0 then
        return default_cmd
    end

    return { "buf", "beta", "lsp", "serve", "--log-format=text" }
end

-- Protobuf LSP
vim.lsp.config("buf_ls", {
    cmd = buf_cmd(),
})

vim.lsp.config("ruby_lsp", require("ruby_lsp"))

vim.lsp.enable({ "pyright", "lua_ls", "buf_ls", "ruby_lsp" })

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },
    underline = true,
})

-- Configure LSP UI handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
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
-- vim.keymap.set("n", "<leader>o", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<cr>", { desc = "Aerial Outline" })
vim.keymap.set("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "Git Status" })

-- LSP
vim.keymap.set("n", "<leader>ca", function()
    vim.lsp.buf.code_action()
end, { desc = "Code Action" })
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

-- NoNeckPain
vim.keymap.set("n", "<leader>np", "<cmd>NoNeckPain<cr>", { desc = "No Neck Pain"})

-- Trouble
vim.keymap.set("n", "<leader>xm", "<cmd>Trouble<cr>", { desc = "Trouble Menu" })
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble Diagnostics" })
vim.keymap.set("n", "<leader>xo", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble objects" })

-- Comment shortcuts (more convenient than gcc)
vim.keymap.set("n", "<C-/>", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, { desc = "Toggle comment" })
vim.keymap.set("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment" })
vim.keymap.set("v", "<leader>/", function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, { desc = "Toggle comment" })

-- Tab management
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
vim.keymap.set("n", "<leader>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>1", "1gt", { desc = "Go to tab 1" })
vim.keymap.set("n", "<leader>2", "2gt", { desc = "Go to tab 2" })
vim.keymap.set("n", "<leader>3", "3gt", { desc = "Go to tab 3" })
vim.keymap.set("n", "<leader>4", "4gt", { desc = "Go to tab 4" })
vim.keymap.set("n", "<leader>5", "5gt", { desc = "Go to tab 5" })

-- Lua
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
local git_blame = require('gitblame')

require('lualine').setup({
    sections = {
        lualine_c = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
        }
    }
})

-- ============================================================================
-- CUSTOM COMMANDS
-- ============================================================================

-- Go YAML Test Command
vim.api.nvim_create_user_command("GoYamlTest", function()
    local filename = vim.fn.expand("%:t")
    vim.cmd('!go test -v ./internal/functional_test -run "^TestApi$/^' .. filename .. '$"')
end, { desc = "Run Go YAML test for current file" })
vim.keymap.set("n", "<leader>gyt", "<cmd>GoYamlTest<cr>", { desc = "Go Yaml Test" })

-- Quit All Command
vim.api.nvim_create_user_command("QQ", function()
    vim.cmd("qall")
end, { desc = "Quit all buffers and windows" })

-- I don't know why but uncommenting out the below will enable ruby
-- local lspconfig = require("lspconfig")
--
-- lspconfig.ruby_lsp.setup({
--   cmd = { "ruby-lsp" },
--   filetypes = { "ruby", "eruby" },
--   root_dir = lspconfig.util.root_pattern("Gemfile", ".ruby-lsp", ".git"),
--   init_options = { formatter = "auto" },
-- })
