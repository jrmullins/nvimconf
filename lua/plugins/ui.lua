return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            on_highlights = function(hl, c)
                -- Use blue instead of orange for snacks picker borders
                hl.SnacksPickerInputBorder = { fg = c.blue1, bg = c.bg_float }
                hl.SnacksPickerInputTitle = { fg = c.blue1, bg = c.bg_float }
                hl.SnacksPickerBoxTitle = { fg = c.blue1, bg = c.bg_float }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Runs on every statusline redraw, so avoid shelling out to git.
            local function get_repo_name()
                local root = vim.fs.root(0, ".git")
                return root and vim.fs.basename(root) or ""
            end

            local function modified_color()
                if vim.bo.modified then
                    return { fg = "#FFFFFF", bg = "#880000" }
                end
            end

            require("lualine").setup({
                options = {
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = {
                        {
                            "filename",
                            path = 1,
                            file_status = true,
                            symbols = {},
                            color = modified_color,
                        },
                    },
                    lualine_b = {
                        { get_repo_name, icon = "" },
                        "branch",
                        "diff",
                        "diagnostics",
                    },
                    lualine_c = {},
                    lualine_x = {
                        "encoding",
                        "filetype",
                    },
                    lualine_y = {
                        "progress",
                    },
                    lualine_z = {
                        "location",
                    },
                },
                inactive_sections = {
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                },
            })
        end,
    },

    {
        "sphamba/smear-cursor.nvim",
        opts = {
            cursor_color = "#0088ff",
            stiffness = 0.3,
            trailing_stiffness = 0.1,
            trailing_exponent = 5,
            damping = 0.5,
            hide_target_hack = true,
            gamma = 1,
        },
    },

    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        keys = {
            { "<leader>np", "<cmd>NoNeckPain<cr>", desc = "Toggle No-Neck-Pain" },
        },
    },
}
