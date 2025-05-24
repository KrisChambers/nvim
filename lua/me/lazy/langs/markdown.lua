return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
        file_types = { "markdown", "Avante" },
        latex = { enabled = false }
    },
    ft = { "markdown", "Avante" },
}
