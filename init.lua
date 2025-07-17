-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "ray-x/go.nvim", dependencies = { "ray-x/guihua.lua", "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" } },
  "nvim-lua/plenary.nvim",
  "hrsh7th/nvim-cmp",
  {"nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup()
    end},
  "nvim-telescope/telescope-file-browser.nvim",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  { "Pocco81/auto-save.nvim", config = true },
  {"Mofiqul/dracula.nvim", name = "dracula",priority = -1},
  {'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'go' },
      highlight = { enable = true },
    }
  end},
  { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end},
  { "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim"},
    config = true
  },
  { 'marko-cerovac/material.nvim' },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
})

-- general options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.g.mapleader = " "

-- Go plugin setup
require("go").setup()

-- Auto-run goimports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
})

-- Autocomplete setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

-- LSP config
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.gopls.setup({
  capabilities = capabilities,
})

-- Telescope keybinds
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

require("telescope").load_extension("file_browser")
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })

vim.keymap.set('n', '<leader>o', ':Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })


-- Set Go tab behavior to use tabs (not spaces), width 8 (per gofmt)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false  -- use tabs, not spaces
    vim.bo.shiftwidth = 8     -- visual width of tab when shifting
    vim.bo.tabstop = 8        -- width of actual tab character
    vim.bo.softtabstop = 8    -- number of spaces inserted for a tab
  end,
})

-- vim.cmd.colorscheme("dracula")
 vim.g.material_style = "Darker"
 --vim.cmd.colorscheme("material")
 vim.cmd.colorscheme("tokyonight")

require("nvim-treesitter.configs").setup({
  ensure_installed = { "go", "lua", "vim", "bash", "markdown" }, -- add more as needed
  highlight = {
    enable = true,
  },
})

vim.keymap.set('i', '<A-Left>', '<C-o>b', { noremap = true })  -- Option + ←
vim.keymap.set('i', '<A-Right>', '<C-o>w', { noremap = true }) -- Option + →

-- Automatically set LSP keymaps when a language server attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Standard Go-to commands
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})

-- shift tab
vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", "<<", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })


