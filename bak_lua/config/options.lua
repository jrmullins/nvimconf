local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true

opt.cmdheight = 2
opt.showcmd = true
opt.showmode = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true

opt.colorcolumn = "80"

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99

vim.cmd("filetype plugin indent on")

vim.g.material_style = "Darker"
