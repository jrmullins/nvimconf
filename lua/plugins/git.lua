return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        -- Gutter bars plus full-line highlights for added/changed lines.
        opts = {
            linehl = true,
        },
        keys = {
            { "]h", "<cmd>Gitsigns nav_hunk next<cr>", desc = "Next git hunk" },
            { "[h", "<cmd>Gitsigns nav_hunk prev<cr>", desc = "Previous git hunk" },
            { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Git preview hunk" },
            { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame line" },
            { "<leader>gh", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle git line highlights" },
            { "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>", desc = "Git undo hunk" },
            { "<leader>gU", "<cmd>Gitsigns reset_buffer<cr>", desc = "Git undo buffer" },
        },
    },
}
