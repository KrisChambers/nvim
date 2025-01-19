function ColorMyWorld(color)
    color = color or "nvimgelion"

    vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
      'nyngwang/nvimgelion',
      config = function ()
            ColorMyWorld()
      end
    }
}

