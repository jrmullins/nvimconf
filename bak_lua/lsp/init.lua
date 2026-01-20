local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
    ruby_lsp = require("lsp.servers.ruby"),
}

for name, config in pairs(servers) do
    local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {})
    vim.lsp.config(name, opts)
end

for name in pairs(servers) do
    vim.lsp.enable(name)
end

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },
    underline = true,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
})
