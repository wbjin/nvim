-- Setup lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader=" "

require("lazy").setup({
    defaults = { lazy = false },
    spec = {
        { import = "plugins" },
    },
    checker = {
        enabled = true,
        notify = false,
        frequency = 3600,
    },
})

require("config.mappings")
require("config.init")
