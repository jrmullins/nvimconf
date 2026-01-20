return {
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "go", "lua", "markdown" },
                highlight = { enable = true },
            })
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
        opts = {},
    },

    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
        },
        ft = { "go", "gomod" },
        event = { "CmdlineEnter" },
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
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
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
}
