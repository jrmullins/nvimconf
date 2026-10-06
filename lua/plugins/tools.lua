return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
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
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble buffer diagnostics" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble symbols" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble LSP" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble loclist" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble quickfix" },
        },
    },

    {
        "SunnyTamang/select-undo.nvim",
        opts = {},
    },
}
