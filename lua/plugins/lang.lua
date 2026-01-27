return {
    { "neovim/nvim-lspconfig" },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            {
                "L3MON4D3/LuaSnip",
                build = (vim.fn.executable("make") == 1 and "make install_jsregexp") or nil,
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.config.setup({})

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,noselect",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

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
}
