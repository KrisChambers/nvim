local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec ={
        { import = "me.lazy" },
        { import = "me.lazy.ai" },
        { import = "me.lazy.lsp" },
        { import = "me.lazy.ui" },
        { import = "me.lazy.langs" },
        { import = "me.lazy.core" },
        { import = "me.lazy.editor" },
    },
    change_detection = { notify = false },
    dev = {
        path = "/home/kris/personal/KrisChambers",
        paterns = {},
        fallback = false
    }
})
