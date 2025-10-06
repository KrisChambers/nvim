vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Directory view containing current file" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move a whole line up 1 line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move a whole line down 1 line" })

vim.keymap.set("n", "J", "mzJ`z",
    { desc = "Move line below the cursor to the end of the cursor maintaining cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down a page and keep the cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up a page and keep the cursor centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Find forward (same as `n`), keeping cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find backward (same as 'N'), keeping cursor centered" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to the system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Can't remember what this does" })

-- Send whatever is deleted to the blackhole so we don't overwrite a yank
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]],
    { desc = "Send the deleted content to the blackhole register so we are not overwriting a yank" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Not sure what this does" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Don't do anything when Q is pressed" })

vim.keymap.set("n", "<leader>q", ":bp <bar> bd #<CR>",
    { desc = "Move to previous buffer and close current buffer - Need more than one buffer" })
vim.keymap.set("n", "<leader>ft", function ()
    vim.lsp.buf.format({
        filter = function(client)
            return (client.name ~= "basedpyright" and client.name ~= "pyright") -- When using python we don't use the parser for formatting
        end
    })
end,
{ desc = "Format current buffer" })

vim.keymap.set({"n", "x"}, "<leader>rr", function ()
    local tele = require("telescope")

    tele.extensions.refactoring.refactors()
end)

--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
--
-- Quick search and replace setup for the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Do a search and replace across the whole file for the word currently under the cursor" })
-- TODO (kc): Check if there is a shebang. If so make executable, else noop
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--vim.keymap.set("n", "<leader><leader>", function()
--    vim.cmd("so")
--end)
