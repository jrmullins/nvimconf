return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },

    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.gitblame_display_virtual_text = 0
        end,
        opts = {
            enabled = true,
            message_template = " <author> • <date> • <summary> • <sha>",
            date_format = "%m-%Y",
            virtual_text_column = 1,
        },
    },
}
