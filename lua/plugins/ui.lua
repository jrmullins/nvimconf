return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "f-person/git-blame.nvim",
        },
        config = function()
            local function get_repo_name()
                local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
                if handle then
                    local result = handle:read("*a")
                    handle:close()
                    if result and result ~= "" then
                        return vim.fn.fnamemodify(result:gsub("\n", ""), ":t")
                    end
                end
                return ""
            end

            local git_blame_available, git_blame = pcall(require, "gitblame")

            local function modified_color()
                if vim.bo.modified then
                    return { fg = "#FFD700" }
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
                    lualine_c = git_blame_available and {
                        {
                            git_blame.get_current_blame_text,
                            cond = git_blame.is_blame_text_available,
                        },
                    } or {},
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
