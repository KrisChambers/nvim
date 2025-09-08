function ColorMyWorld(color)
    color = color or "flexoki"

    vim.cmd.colorscheme(color)

    -- Goal is to set a single background in our window manager that will be able to be seen
    -- through the terminal and nvim. At the very least have it set in the terminal.
    --vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local function enabled()
    ColorMyWorld()
end

local function disabled()
end

return {
    {
        'rebelot/kanagawa.nvim',
        config = disabled
    },
    {
        'tiagovla/tokyodark.nvim',
        config = disabled
    },
    { "nuvic/flexoki-nvim", name = "flexoki", config = enabled }
}
