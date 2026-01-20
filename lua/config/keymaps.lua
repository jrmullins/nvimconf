local map = vim.keymap.set

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>k", function()
    vim.lsp.buf.signature_help()
end, { desc = "Signature help" })
