vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y"]], { desc = "Yank to the system clipboard" })
vim.keymap.set("n", "<leader>w", vim.cmd.Ex, { desc = "Directory view containing current file" })



