vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

-- NOTE (kc): I think i want to do this a different way.
-- IDEA: (kc):
--
-- We want to provide a seaparation based on "tasks" i.e What are we trying to achieve right now?
-- Example: There may be a situation where we are using some code as inspiration / cut / paste / refactoring in something
-- We are currently doing. We want these files to be in buffers in the same nvim instance. In this sense tmux-sessionizer is
-- a bit of a failure.
--
-- At the same time we want the above situation to be such that those two files / projects can be developed independently
--
-- 1. Instead of using tmux we could use wezterm.
-- 2. Wezterm can multiplex, but we could also use the tabs in wezterm.
-- 3, We want to use tabs in two different ways.
--      1. A Session should consist of a completely different and separate tasks.
--      2. Everything that happens inside nvim should be pertaining to a current task.
--      3. Tabs in NVIM should be different workspaces, potentially different projects, but yanking and what not between them will be easier.
--      4.
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
--
--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
--
--vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--
--vim.keymap.set(
--    "n",
--    "<leader>ee",
--    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
--)

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
