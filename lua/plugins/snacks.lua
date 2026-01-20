return {
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 900,
        opts = {
            picker = { enabled = true },
            dashboard = { enabled = true },
            dim = { enabled = true },
            explorer = {
                enabled = true,
                replace_netrw = true,
                layout = {
                    preset = "sidebar",
                    width = 30,
                    position = "right",
                },
            },
            gh = { enabled = true },
            git = {
                enabled = true,
                blame = { enabled = true, format = "<author> • <summary>" },
            },
            input = { enabled = true },
            notifier = { enabled = true },
            animate = { enabled = true },
            scroll = { enabled = true },
            zen = {
                enabled = true,
                toggles = { dim = true },
            },
            indent = {
                enabled = true,
                scope = { enabled = false },
                -- filter = function(buf)
                --     return vim.bo[buf].filetype == "yaml"
                -- end,
            },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("snacks").picker.files()
                end,
                desc = "Find files (Snacks)",
            },
            {
                "<leader>fg",
                function()
                    require("snacks").picker.grep()
                end,
                desc = "Live grep (Snacks)",
            },
            {
                "<leader>ft",
                function()
                    require("snacks").explorer()
                end,
                desc = "Explorer (Snacks)",
            },
            {
                "<leader>gs",
                function()
                    require("snacks").picker.git_status()
                end,
                desc = "Git status (Snacks)",
            },
            {
                "<leader>o",
                function()
                    require("snacks").picker.symbols()
                end,
                desc = "Symbols outline (Snacks)",
            },
            {
                "<leader>zz",
                function()
                    require("snacks").zen()
                end,
                desc = "Toggle Zen (Snacks)",
            },
            {
                "<leader>sd",
                function()
                    require("snacks").dim()
                end,
                desc = "Toggle dim (Snacks)",
            },
        },
    },
}
