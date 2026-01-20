-- Core options must be set before plugins load
require("config.options")

-- Plugin manager and specs
require("plugins")

-- Core UX bits
require("config.autocmds")
require("config.keymaps")
require("config.commands")

-- Language Servers
require("lsp")

-- Cosmetics last for faster productivity
require("config.colors")
