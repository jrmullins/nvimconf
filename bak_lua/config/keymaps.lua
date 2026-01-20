local map = vim.keymap.set

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fd", "<cmd>Telescope file_browser<cr>", { desc = "File browser" })
map("n", "<leader>o", "<cmd>AerialToggle!<cr>", { desc = "Outline" })
map("n", "<leader>gs", function()
    require("telescope.builtin").git_status()
end, { desc = "Git status" })

-- LSP helpers
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>e", function()
    vim.diagnostic.open_float(nil, { border = "rounded", focus = false })
end, { desc = "Line diagnostics" })

-- UI toggles
map("n", "<leader>ft", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })
map("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Claude Code" })
map("n", "<leader>np", "<cmd>NoNeckPain<cr>", { desc = "No Neck Pain" })

-- Trouble
map("n", "<leader>xm", "<cmd>Trouble<cr>", { desc = "Trouble menu" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
map("n", "<leader>xo", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble symbols" })

-- Comments
map("n", "<C-/>", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
map("v", "<C-/>", function()
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment" })
map("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
map("v", "<leader>/", function()
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>1", "1gt", { desc = "Tab 1" })
map("n", "<leader>2", "2gt", { desc = "Tab 2" })
map("n", "<leader>3", "3gt", { desc = "Tab 3" })
map("n", "<leader>4", "4gt", { desc = "Tab 4" })
map("n", "<leader>5", "5gt", { desc = "Tab 5" })

-- Insert mode helpers
map("i", "<A-Left>", "<C-o>b", { desc = "Back word" })
map("i", "<A-Right>", "<C-o>w", { desc = "Forward word" })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })
map("n", "<S-Tab>", "<<", { desc = "Unindent line" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })
