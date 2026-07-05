return {
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            -- configuration goes here
            -- THIS IS THE PREFERRED LANGUAGE YOU WANT TO USE IN LEETCODE SO IT'S IMPORTANT
            lang = "python",
        },
    },
}
