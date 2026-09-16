return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "snacks_picker_list",
                callback = function()
                    wk.add({
                        { "a", desc = "Add file/dir" },
                        { "d", desc = "Delete" },
                        { "r", desc = "Rename" },
                        { "m", desc = "Move" },
                        { "c", desc = "Copy" },
                        { "<Tab>", desc = "Select" },
                        { "y", desc = "Yank path" },
                        { "p", desc = "Paste" },
                        { "o", desc = "Open with system app" },
                        { "u", desc = "Refresh" },
                        { "H", desc = "Toggle hidden" },
                        { "I", desc = "Toggle ignored" },
                        { ".", desc = "Set cwd" },
                        { "P", desc = "Toggle preview" },
                        { "<CR>", desc = "Open/toggle dir" },
                        { "h", desc = "Close dir / go up" },
                        { "<BS>", desc = "Go up" },
                        { "Z", desc = "Close all" },
                        { buffer = 0 },
                    })
                end,
            })
        end,
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
