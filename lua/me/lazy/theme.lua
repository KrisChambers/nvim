function ColorMyWorld(color)
    color = color or "cyberdream"

    vim.cmd.colorscheme(color)

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
            ColorMyWorld("cyberdream")
        end
    }
}
