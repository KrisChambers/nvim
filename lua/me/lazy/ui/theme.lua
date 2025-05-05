function ColorMyWorld(color)
    color = color or "cyberdream"

    vim.cmd.colorscheme(color)

    -- Goal is to set a single background in our window manager that will be able to be seen
    -- through the terminal and nvim. At the very least have it set in the terminal.
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        'nyngwang/nvimgelion',
        config = function()
            -- ColorMyWorld()
        end
    },
    {
        "EdenEast/nightfox.nvim",
        config = function()
--            ColorMyWorld("nightfox")
        end

    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                variant="auto"
            })

            ColorMyWorld("cyberdream")
        end
    }
}
