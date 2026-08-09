local util = require("lspconfig.util")

local function find_python_path()
    local patterns = {
        "./venv/bin/python",
        "./.venv/bin/python",
        "./backend/venv/bin/python",
        "./env/bin/python",
    }

    for _, path in ipairs(patterns) do
        if vim.fn.executable(path) == 1 then
            return path
        end
    end

    return "python3"
end

return {
    settings = {
        python = {
            pythonPath = find_python_path(),
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
    root_dir = util.root_pattern("pyrightconfig.json", "pyproject.toml", "setup.py", ".git"),
}
