return {
    {
        "mfussenegger/nvim-dap"
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function ()
            require('dap-python').setup("uv")
        end
    }
}
