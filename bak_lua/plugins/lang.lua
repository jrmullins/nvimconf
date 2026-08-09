return {
    { "neovim/nvim-lspconfig" },


    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
        },
        opts = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            return {
                lsp_keymaps = false,
                lsp_cfg = {
                    capabilities = capabilities,
                    settings = {
                        gopls = {
                            gofumpt = true,
                            usePlaceholders = true,
                            analyses = {
                                unusedparams = true,
                                shadow = true,
                            },
                            staticcheck = true,
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            require("go").setup(opts)
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()'
    },

    {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
            "ibhagwan/fzf-lua",
        },
    },

    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "go", "lua", "vim", "bash", "markdown", "yaml", "python", "proto", "sql", "ruby" },
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
        end,
    },
}
