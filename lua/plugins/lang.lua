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
                    -- ST1000 (package comment form) is off: most packages
                    -- don't need one, and copyright headers trip it.
                    settings = { gopls = { analyses = { ST1000 = false } } },
                },
                lsp_keymaps = false,
            }
        end,
        config = function(_, opts)
            require("go").setup(opts)
            -- Don't attach gopls to non-file buffers (e.g. diffview:// revisions):
            -- gopls rejects non-file URIs with "JSON RPC parse error".
            local default_root = vim.lsp.config.gopls.root_dir
            vim.lsp.config("gopls", {
                root_dir = function(bufnr, on_dir)
                    if vim.api.nvim_buf_get_name(bufnr):match("^%a[%w+.-]*://") then
                        return
                    end
                    if type(default_root) == "function" then
                        default_root(bufnr, on_dir)
                    else
                        on_dir(vim.fs.root(bufnr, { "go.work", "go.mod", ".git" }))
                    end
                end,
            })
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
