return {
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            linehl = true,
        },
        keys = {
            { "<leader>gh", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle git line highlights" },
            { "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>", desc = "Git undo hunk" },
            { "<leader>gU", "<cmd>Gitsigns reset_buffer<cr>", desc = "Git undo buffer" },
        },
    },
}
