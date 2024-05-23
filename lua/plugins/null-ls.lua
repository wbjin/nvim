return {
    "jose-elias-alvarez/null-ls.nvim",
    lazy=false,
    event = "VeryLazy",
    opts = function()
      return require "plugins.config.null-ls"
    end
}
