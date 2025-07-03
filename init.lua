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

local function find_python_lib_dir(venv_root)
  local handle = io.popen("find " .. venv_root .. "/lib -maxdepth 1 -type d -name 'python3.*'")
  if handle then
    local result = handle:read("*l")
    handle:close()
    return result
  end
end

local cwd = vim.fn.getcwd()
local venv_root = cwd .. "/.venv"  -- adjust if needed
local python_path = venv_root .. "/bin/python"
local python_lib = find_python_lib_dir(venv_root)

lspconfig.pyright.setup({
  settings = {
    python = {
      pythonPath = python_path,
      venvPath = venv_root,
      venv = ".venv",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

lspconfig.ruff.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd_env = {
    PYTHONPATH = python_lib and (python_lib .. "/site-packages") or "",
  },
})


require("config.mappings")
require("config.init")
