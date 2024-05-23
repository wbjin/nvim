return {
    "williamboman/nvim-lsp-installer",
    lazy=false,
    dependencies = "neovim/nvim-lspconfig",
    config = function()
        require("nvim-lsp-installer").setup({
            automatic_installation = false, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
       })
    end
}
