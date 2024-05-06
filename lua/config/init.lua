local opt = vim.opt
local g = vim.g

opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

opt.number = true
opt.numberwidth = 2
opt.ruler = false


opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.textwidth = 100
vim.wo.wrap = true
vim.cmd(":set textwidth=100")
vim.cmd(":set colorcolumn=100")
vim.cmd(":set wrap")

vim.cmd(":set number")
