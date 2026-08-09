local map = vim.keymap.set

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>k", function()
    vim.lsp.buf.signature_help()
end, { desc = "Signature help" })

map("n", "<leader>n", function()
    vim.ui.input({ prompt = "New file: ", completion = "file" }, function(path)
        if path and path ~= "" then
            local resolved = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
            if vim.fn.confirm("Create " .. resolved .. "?", "&Yes\n&No", 2) == 1 then
                vim.fn.mkdir(vim.fn.fnamemodify(resolved, ":h"), "p")
                vim.cmd.edit(resolved)
            end
        end
    end)
end, { desc = "New file" })
