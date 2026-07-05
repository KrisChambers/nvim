return {
  {
    "3rd/image.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("image").setup({
        backend = "kitty",
        max_width = nil,
        max_height = nil,
        magick_threshold = 0,
      })
    end,
  },
}
