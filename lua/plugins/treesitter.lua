local options = {
  ensure_installed = { "lua", "c", "python" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

return {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = options,
    lazy=false,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
}
