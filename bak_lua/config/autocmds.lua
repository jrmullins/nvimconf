local group = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
        vim.bo.softtabstop = 8
    end,
})
