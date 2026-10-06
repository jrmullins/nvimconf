-- Core options must be set before plugins load (leader key in particular)
require("config.options")

-- Plugin manager; loads every spec in lua/plugins/
require("config.lazy")

-- Global keymaps
require("config.keymaps")

-- Language Servers
require("lsp")
