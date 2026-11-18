return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        -- Gutter bars plus full-line highlights for added/changed lines.
        opts = {
            linehl = true,
            -- Inline blame at end of cursor line, e.g. "a_user 12/25/2026".
            current_line_blame = true,
            current_line_blame_formatter = "<author> <author_time:%m/%d/%Y>",
        },
        keys = {
            { "<leader>GS", "<cmd>Gitsigns diff<cr>", desc = "Git diff review" },
            { "]h", "<cmd>Gitsigns nav_hunk next<cr>", desc = "Next git hunk" },
            { "[h", "<cmd>Gitsigns nav_hunk prev<cr>", desc = "Previous git hunk" },
            { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Git preview hunk" },
            { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame line" },
            { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle inline git blame" },
            { "<leader>gh", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle git line highlights" },
            { "<leader>gu", "<cmd>Gitsigns reset_hunk<cr>", desc = "Git undo hunk" },
            { "<leader>gU", "<cmd>Gitsigns reset_buffer<cr>", desc = "Git undo buffer" },
        },
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        keys = {
            -- Toggle: one key opens the review tab and closes it again.
            {
                "<leader>dv",
                function()
                    if require("diffview.lib").get_current_view() then
                        vim.cmd("DiffviewClose")
                    else
                        vim.cmd("DiffviewOpen")
                    end
                end,
                desc = "Toggle diffview",
            },
        },
    },
}
