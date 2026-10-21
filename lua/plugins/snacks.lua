-- Show dotfiles and .gitignore'd files (e.g. deploy/tilt/locals-*.yaml), but keep
-- dependency trees out of the way. `.git` is always excluded by snacks.
-- Toggle at runtime: files picker <A-h>/<A-i>, explorer H/I.
local file_filter = {
    hidden = true,
    ignored = true,
    exclude = { "vendor", "node_modules" },
}

-- Running gopls clients, or a new one started without a Go buffer (e.g. from the
-- dashboard). Outside a module it covers every go.mod under cwd, so a folder of
-- separate modules (no go.work) is searched as one. Go files opened later reuse
-- this client, since their module is one of its workspace folders.
local function gopls_clients()
    local clients = vim.lsp.get_clients({ name = "gopls" })
    if #clients > 0 then
        return clients
    end

    local cwd = vim.uv.cwd()
    local roots = { vim.fs.root(cwd, "go.mod") }
    if #roots == 0 then
        local skip = { vendor = true, node_modules = true, [".git"] = true }
        local mods = vim.fs.find("go.mod", {
            path = cwd,
            limit = math.huge,
            skip = function(dir) return not skip[dir] end,
        })
        roots = vim.tbl_map(vim.fs.dirname, mods)
    end
    if #roots == 0 then
        return {}
    end

    local config = vim.deepcopy(vim.lsp.config.gopls)
    config.root_dir = roots[1]
    config.workspace_folders = vim.tbl_map(function(root)
        return { uri = vim.uri_from_fname(root), name = root }
    end, roots)
    local id = vim.lsp.start(config, { attach = false })
    return id and { vim.lsp.get_client_by_id(id) } or {}
end

-- Workspace symbols from gopls, whatever buffer is current. Snacks' own
-- lsp_workspace_symbols only asks servers attached to the current buffer.
local function go_symbols()
    local clients = gopls_clients()
    if #clients == 0 then
        Snacks.notify("No go.mod in or under " .. vim.uv.cwd())
        return
    end

    Snacks.picker.lsp_workspace_symbols({
        title = "Go Symbols",
        finder = function(opts, ctx)
            local lsp = require("snacks.picker.source.lsp")
            local kinds = opts.filter.go or opts.filter.default
            return function(cb)
                for _, client in ipairs(clients) do
                    lsp.request(client, "workspace/symbol", function()
                        return { query = ctx.filter.search }
                    end, function(c, result)
                        for _, item in ipairs(lsp.results_to_items(c, result, { text_with_file = true })) do
                            if kinds == true or vim.tbl_contains(kinds, item.kind) then
                                cb(item)
                            end
                        end
                    end)
                end
            end
        end,
        on_show = function(picker)
            -- A fresh gopls answers with nothing until packages load; search
            -- again once its progress reports finish.
            vim.api.nvim_create_autocmd("LspProgress", {
                pattern = "end",
                callback = function(ev)
                    if picker.closed then
                        return true
                    end
                    if vim.tbl_contains(vim.tbl_map(function(c) return c.id end, clients), ev.data.client_id) then
                        picker:find()
                    end
                end,
            })
        end,
    })
end

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
            -- Images and ```mermaid blocks in markdown. Needs `mmdc` and `magick`
            -- (`make diagrams`). WezTerm can't render inline, so they show in a
            -- float when the cursor is on them. Debug with :checkhealth snacks.
            image = { enabled = true },
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
            { "<leader>fs", go_symbols, desc = "Go symbols (Snacks)" },
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
            {
                "<leader>si",
                function()
                    -- snacks.image has no off switch, so drop (or re-attach) the
                    -- buffer's CursorMoved autocmd that opens the image float.
                    local buf = vim.api.nvim_get_current_buf()
                    if vim.b[buf].snacks_image_attached then
                        pcall(vim.api.nvim_del_augroup_by_name, "snacks.image.doc." .. buf)
                        Snacks.image.doc.hover_close()
                        vim.b[buf].snacks_image_attached = false
                        Snacks.notify("Image previews off")
                    else
                        Snacks.image.doc.attach(buf)
                        Snacks.notify("Image previews on")
                    end
                end,
                desc = "Toggle image previews (Snacks)",
            },
        },
    },
}
