return {
    { "neovim/nvim-lspconfig" },

    -- Teaches lua_ls about the Neovim runtime (`vim.*`) and installed plugins,
    -- but only loads library types when a file actually requires them.
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local langs = { "go", "lua", "markdown", "markdown_inline", "proto", "python", "yaml" }
            require("nvim-treesitter").install(langs):wait(300000)

            -- The nvim-treesitter rewrite dropped `highlight = { enable = true }`,
            -- so highlighting is started per filetype for the parsers above.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = vim.iter(langs):map(vim.treesitter.language.get_filetypes):flatten():totable(),
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    {
        "ray-x/go.nvim",
        lazy = false,
        dependencies = {
            "ray-x/guihua.lua",
        },
        opts = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            return {
                lsp_cfg = {
                    capabilities = capabilities,
                },
                lsp_keymaps = false,
            }
        end,
        config = function(_, opts)
            require("go").setup(opts)
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimports()
                end,
                group = format_sync_grp,
            })
        end,
        build = ':lua require("go.install").update_all_sync()',
    },
    {
        "nvim-flutter/flutter-tools.nvim",
        ft = "dart",
        dependencies = { "nvim-lua/plenary.nvim" }, -- vim.ui.select is handled by snacks.picker
        config = true,
    },
}
