return {
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            linehl = false,
        },
        keys = {
            { "<leader>gh", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle git line highlights" },
        },
    },
}
