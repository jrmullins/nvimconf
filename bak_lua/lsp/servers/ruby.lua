local util = require("lspconfig.util")

return {
    cmd = { "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    root_dir = util.root_pattern("Gemfile", ".ruby-lsp", ".git"),
    init_options = {
        formatter = "auto",
    },
    reuse_client = function(client, config)
        config.cmd_cwd = config.root_dir
        return client.config.cmd_cwd == config.cmd_cwd
    end,
}
