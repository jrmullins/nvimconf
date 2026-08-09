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

local modules = {
    "plugins.lang",
    "plugins.completion",
    "plugins.files",
    "plugins.git",
    "plugins.ui",
    "plugins.misc",
}

local specs = {}
for _, module in ipairs(modules) do
    local ok, chunk = pcall(require, module)
    if ok and chunk then
        vim.list_extend(specs, chunk)
    else
        vim.notify(("Failed loading %s: %s"):format(module, chunk), vim.log.levels.ERROR)
    end
end

require("lazy").setup(specs)

return specs
