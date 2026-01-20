vim.api.nvim_create_user_command("GoYamlTest", function()
    local filename = vim.fn.expand("%:t")
    vim.cmd('!go test -v ./internal/functional_test -run "^TestApi$/^' .. filename .. '$"')
end, { desc = "Run Go YAML test for current file" })

vim.keymap.set("n", "<leader>gyt", "<cmd>GoYamlTest<cr>", { desc = "Go YAML test" })

vim.api.nvim_create_user_command("QQ", function()
    vim.cmd("qall")
end, { desc = "Quit all buffers and windows" })
