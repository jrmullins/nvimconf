local ok, _ = pcall(vim.cmd.colorscheme, "tokyonight-night")
if not ok then
    vim.cmd.colorscheme("default")
end
