return {
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            picker = { 
                enabled = true,
                sources = {
                    explorer = {
                        layout = { layout = { position = "right", width = 25 } },
                        -- auto_close = true,
                        -- layout = {
                            -- { preview = true },
                            -- layout = {
                            --     box = 'horizontal',
                            --     width = 0.8,
                            --     height = 0.8,
                            --     {
                            --         box = 'vertical',
                            --         border = 'rounded',
                            --         title = '{source} {live} {flags}',
                            --         title_pos = 'center',
                            --         { win = 'input', height = 1, border = 'bottom' },
                            --         { win = 'list', border = 'none' },
                            --     },
                            --     { win = 'preview', border = 'rounded', width = 0.7, title = '{preview}' },
                            -- },
                        -- },
                    },
                },
            },
            dashboard = { 
                enabled = true,
                preset = {
                    header = [[
  ▘      ▜   ▖       ▘    
▛▘▌▛▌▛▌▀▌▐   ▝▖  ▛▌▛▌▌▛▘█▌
▄▌▌▙▌▌▌█▌▐▖  ▞   ▌▌▙▌▌▄▌▙▖
   ▄▌                     
                 ]],
                },
            },
            dim = { enabled = true },
            explorer = {
                enabled = true,
                replace_netrw = true,
                layout = {
                    preset = "sidebar",
                    -- width = 20,
                    -- position = "right",
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
                    "<leader>z",
                    function()
                        require("snacks").zen()
                    end,
                    desc = "Toggle Zen Mode(Snacks)",
                },
                {
                    "<leader>Z",
                    function()
                        require("snacks").zen.zoom()
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
