local function buf_map(bufnr, mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        buf_map(bufnr, "n", "gd", vim.lsp.buf.definition, "Go to definition")
        buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        buf_map(bufnr, "n", "gI", vim.lsp.buf.implementation, "Go to implementation")
        buf_map(bufnr, "n", "gr", vim.lsp.buf.references, "References")
        buf_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover")
        buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        buf_map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
})
