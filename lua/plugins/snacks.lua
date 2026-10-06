-- Show dotfiles and .gitignore'd files (e.g. deploy/tilt/locals-*.yaml), but keep
-- dependency trees out of the way. `.git` is always excluded by snacks.
-- Toggle at runtime: files picker <A-h>/<A-i>, explorer H/I.
local file_filter = {
    hidden = true,
    ignored = true,
    exclude = { "vendor", "node_modules" },
}

return {
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            picker = {
                enabled = true,
                sources = {
                    files = file_filter,
                    explorer = vim.tbl_extend("force", file_filter, {
                        layout = { layout = { position = "right", width = 25 } },
                    }),
                },
            },
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
  ▘      ▜   ▖       ▘    
▛▘▌▛▌▛▌▀▌▐   ▝▖  ▛▌▛▌▌▛▘█▌
▄▌▌▙▌▌▌█▌▐▖  ▞   ▌▌▙▌▌▄▌▙▖
   ▄▌                     
                 ]],
                },
            },
            dim = { enabled = true },
            explorer = { enabled = true, replace_netrw = true },
            gh = { enabled = true },
            git = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
            animate = { enabled = true },
            scroll = { enabled = true },
            zen = {
                enabled = true,
                toggles = { dim = true },
            },
            indent = {
                enabled = true,
                scope = { enabled = false },
            },
        },
        keys = {
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files (Snacks)" },
            { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep (Snacks)" },
            { "<leader>ft", function() Snacks.explorer() end, desc = "Explorer (Snacks)" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status (Snacks)" },
            {
                "<leader>o",
                function()
                    local buf = 0

                    -- lsp_symbols opens an empty picker rather than erroring when
                    -- nothing can answer, so pcall can't detect this case. Check
                    -- capability directly. bufls, for instance, attaches to .proto
                    -- but does not implement textDocument/documentSymbol.
                    local lsp_ok = #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentSymbol" }) > 0

                    -- The treesitter picker needs a locals query; proto and markdown
                    -- don't ship one upstream, so bail with a message instead of
                    -- opening an empty list.
                    if not lsp_ok and not vim.treesitter.query.get(vim.bo[buf].filetype, "locals") then
                        Snacks.notify("No symbol source for " .. vim.bo[buf].filetype .. " filetype")
                        return
                    end

                    -- Note: the picker is `treesitter`, not `treesitter_symbols`.
                    -- `treesitter_symbols` is the finder name, not the picker field.
                    Snacks.picker[lsp_ok and "lsp_symbols" or "treesitter"]()
                end,
                desc = "Symbols outline (Snacks)",
            },
            { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode (Snacks)" },
            { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom (Snacks)" },
            { "<leader>sd", function() Snacks.dim() end, desc = "Toggle dim (Snacks)" },
        },
    },
}
