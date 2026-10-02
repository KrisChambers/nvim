vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/folke/which-key.nvim"
})

require("telescope").setup({})
require("trouble").setup({})
require("which-key").setup({})

-- ### Telescope

local b = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", b.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", b.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", b.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", b.help_tags, { desc = "Help" })


-- ### Trouble

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })

-- ### Which-key
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer local Keymaps (which-key)" })
