return {
    'chipsenkbeil/distant.nvim', 
    lazy=false,
    branch = 'v0.3',
    config = function()
        require('distant'):setup()
    end
}
