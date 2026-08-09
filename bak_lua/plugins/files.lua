return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            local open_after_tree = function(prompt_bufnr)
                vim.defer_fn(function()
                    actions.select_default(prompt_bufnr)
                end, 100)
            end
            local telescope = require("telescope")
            telescope.setup({
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = true,
                        find_command = { "rg", "--files", "--sortr=modified" },
                    },
                },
                defaults = {
                    file_ignore_patterns = {
                        "%.git/",
                        "node_modules/",
                        "venv/",
                        "gen/",
                    },
                    mappings = {
                        i = { ["<CR>"] = open_after_tree },
                        n = { ["<CR>"] = open_after_tree },
                    },
                },
            })
            telescope.load_extension("file_browser")
        end,
    },

    "nvim-telescope/telescope-file-browser.nvim",

    {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 30,
                    side = "right",
                    preserve_window_proportions = true,
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = false,
                },
                renderer = {
                    highlight_git = true,
                    icons = {
                        show = {
                            git = true,
                            folder = true,
                            file = true,
                            folder_arrow = true,
                        },
                    },
                },
            })
        end,
    },

    {
        "stevearc/aerial.nvim",
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
