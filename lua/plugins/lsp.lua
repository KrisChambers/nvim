-- Setup LSPs
vim.print("Enabling LSPs")

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    -- "https://github.com/mason-org/mason.nvim",
    -- "https://github.com/mason-org/mason-lspconfig.nvim",
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

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

local servers = {
    "lua_ls",   -- Lua language server
    "nil_ls",      -- Nix Language server
    --"bash",   -- Bash language server?
    -- ?
}

local function available_to_start(name)
    local cfg = vim.lsp.config[name]

    if not cfg or not cfg.cmd then
        return false
    end

    if type(cfg.cmd) == "function" then
        return true
    end

    local bin = type(cfg.cmd) == "table" and cfg.cmd[1]

    return type(bin) == "string" and vim.fn.executable(bin) == 1
end

-- We are skipping the enabling of any servers that are not available in the environment
for _, name in ipairs(servers) do
    if available_to_start(name) then
        vim.lsp.enable(name)
    end
end

vim.diagnostic.config({ virtual_text = true, severity_sort = true })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.keymap.set("n", "<leader>ft", function()
            vim.lsp.buf.format({ async = true })
        end, { buffer = ev.buf, desc = "Format" })
        -- grn / gra / grr / gri / grt are already mapped by Neovim
    end,
})
