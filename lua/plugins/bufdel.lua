return {
    "ojroques/nvim-bufdel",
    lazy=false,
    config=function()
        _, bufdel = pcall(require, "bufdel")
        bufdel.setup {
            next="tabs",
            quit=false,
        }
    end
}
