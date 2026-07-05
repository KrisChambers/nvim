return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    config = function ()
        require("telescope").load_extension("refactoring")
        require("refactoring").setup({
            prompt_func_param_type = {
                python = true
            },
            prompt_func_return_type = {
                python = true
            }
        })
    end
}
