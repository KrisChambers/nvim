-- lua/plugins/lsp.lua

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/rafamadriz/friendly-snippets", -- optional snippet collection
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("^1"), -- tagged releases only, so prebuilt binaries are used
    },
})

-- Completion ---------------------------------------------------------------
require("blink.cmp").setup({
    keymap = { preset = "default" },

    completion = {
        list = {
            selection = { preselect = false, auto_insert = false },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },

    -- Falls back to a slower pure-Lua matcher if the Rust binary can"t be found
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- LSP ----------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls" }, -- installed servers are auto-enabled
})

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.diagnostic.config({ virtual_text = true, severity_sort = true })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.keymap.set("n", "<leader>ft", function()
            vim.lsp.buf.format({ async = true })
        end, { buffer = ev.buf, desc = "Format" })
        -- grn / gra / grr / gri / grt are already mapped by Neovim
    end,
})
