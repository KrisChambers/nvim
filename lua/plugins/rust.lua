vim.pack.add({
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
})

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
      },
    },
  },
}

