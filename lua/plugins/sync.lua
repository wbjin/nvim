return {
    "wbjin/sync-nvim",
    -- dir="/Users/wonbinjin/projects/sync",
    lazy=false,
    config = function()
        require("sync").setup()
    end,
}
