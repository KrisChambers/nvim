return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
        "BufReadPre " .. vim.fn.expand "~" .. "/personal/vaults/**/*.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/personal/vaults/**/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    ---@module "obsidian"
    ---@type obsidian.config
    opts = {
        legacy_commands=false,
        workspaces = {
            {
                name = "personal",
                path = "~/personal/vaults/personal"
            },
            {
                name = "disc-world",
                path = "~/personal/vaults/disc-world",
            },
        },
        ---@diagnostic disable-next-line: missing-fields
        ui = {
            enable = false,
            enabled = false
        },
        -- completion = {
        --     blink = true,
        --     nvim_cmp = false
        -- },
        daily_notes = {
            folder = "daily_notes",
            workdays_only = false
        }
    },
}
