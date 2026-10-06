local function buf_map(bufnr, mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

-- Virtual text is off by default since 0.11; underline/signs are already on.
vim.diagnostic.config({ virtual_text = true })

-- Servers use nvim-lspconfig's defaults as-is. Each is only enabled if its
-- binary is on PATH (install with `make lsp`), so a missing server degrades
-- quietly instead of erroring when a matching file opens.
--   buf_ls   protobuf: `buf lsp serve` (mise); formatting + lint from buf.yaml
--   lua_ls   Lua; lazydev.nvim (lua/plugins/lang.lua) adds Neovim API types
--   ruby_lsp Ruby (gem in the mise-managed ruby)
--   yamlls   YAML (npm); document symbols power <leader>o for YAML keys
-- gopls is not listed here: go.nvim (lua/plugins/lang.lua) manages it.
local servers = {
    buf_ls = "buf",
    lua_ls = "lua-language-server",
    ruby_lsp = "ruby-lsp",
    yamlls = "yaml-language-server",
}
for server, bin in pairs(servers) do
    if vim.fn.executable(bin) == 1 then
        vim.lsp.enable(server)
    end
end

-- Format on save for proto files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.proto",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf
        buf_map(bufnr, "n", "gd", vim.lsp.buf.definition, "Go to definition")
        buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        buf_map(bufnr, "n", "gI", vim.lsp.buf.implementation, "Go to implementation")
        -- nowait: fire immediately instead of waiting to see if this is one of
        -- Neovim's built-in gr* maps (grn, gra, grr, ...).
        vim.keymap.set("n", "gr", function()
            Snacks.picker.lsp_references()
        end, { buffer = bufnr, nowait = true, desc = "References" })
        buf_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover")
        buf_map(bufnr, "n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")
        buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        buf_map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
})
