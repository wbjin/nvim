return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy=false,
    config = function()
        _, bufferline = pcall(require, "bufferline")
        vim.opt.termguicolors = true
        bufferline.setup {
            options = {
                mode = "buffer",
                style_preset = bufferline.style_preset.default,
                themable=true,
                offsets={{filetype="NvimTree", text="", padding=1}},
            },
        }
    end
}
