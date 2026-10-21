local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.clipboard = "unnamedplus"
-- ms of idle before CursorHold fires (default 4000); drives the LSP auto-hover
opt.updatetime = 5000
