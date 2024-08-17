return {
    {
        "zbirenbaum/copilot.lua",
        config = function()

            require('copilot').setup({


            })
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        version = "v2.11.0",
        --branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
        },
        opts = {
            debug = true, -- Enable debugging
            -- See Configuration section for rest
        }
        -- See Commands section for default commands if you want to lazy load on them
    },
}
