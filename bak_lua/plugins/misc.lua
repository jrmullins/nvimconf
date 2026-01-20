return {
    "nvim-lua/plenary.nvim",

    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    {
        "folke/snacks.nvim",
        opts = {
            input = { enabled = true },
            picker = { enabled = true },
        },
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
        end,
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
    },
}
