-- Setup lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader=" "

vim.env.Path = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and "; " or ":") .. vim.env.PATH

vim.cmd [[let $RUST_LOG="error"]]

vim.o.wrap = true
vim.o.linebreak = true

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

local lspconfig = require("lspconfig")
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "-compile-commands-dir=./compile_flags.txt"
    },
    init_options = {
        fallbackFlags = {'--std=c++20'}
    },
}

lspconfig.gopls.setup({
    cmd = { "/Users/wonbinjin/go/bin/gopls" },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
            unusedparams = true,
            },
        },
    },
})

local util = require('lspconfig/util')
local path = util.path

lspconfig.pyright.setup({
    settings = {
        python = {
            venvPath = vim.fn.getcwd() .. "/env/bin/python3",
            venv = "env",
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
            pythonPath = vim.fn.getcwd() .. "/env/bin/python3"
        },
    },
})

-- lspconfig.ruff_lsp.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd_env = {
--     PYTHONPATH = vim.fn.getcwd() .. "/env/lib/python3.11/site-packages", -- adjust for your Python version
--   },
-- })

require("config.mappings")
require("config.init")
