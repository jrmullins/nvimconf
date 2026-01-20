local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local modules = { "plugins.lang", "plugins.snacks", "plugins.ui", "plugins.tools" }
local specs = {}
for _, module in ipairs(modules) do
    local ok, mod_specs = pcall(require, module)
    if ok then
        vim.list_extend(specs, mod_specs)
    else
        vim.notify(("Failed to load %s: %s"):format(module, mod_specs), vim.log.levels.ERROR)
    end
end

require("lazy").setup(specs, {
    rocks = {
        enabled = false,
    },
})
