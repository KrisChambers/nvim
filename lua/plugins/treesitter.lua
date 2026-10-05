--- Neovim comes with the core treesitter integrated, but only has a small number of language
--- parsers available.
---
--- nvim-treesitter provides us with a way to manage the language parsers.

-- Whenever we update nvim-treesitter package want to run TSUpdate
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local data = ev.data
        if data.spec.name == "nvim-treesitter"
            and (data.kind == "install" or data.kind == "update") then
            if not data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

-- Add the plugin
vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Auto-install missing parsers, then start highlighting.
local ts = require("nvim-treesitter")
ts.setup({})

-- Whenever we open a buffer with a filetype we try to determine
-- if the treesitter language is installed or if we can install one.
-- Then install it and start it for the buffer.
local installing = {}
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end

        local function start()
            if vim.api.nvim_buf_is_valid(args.buf) then
                pcall(vim.treesitter.start, args.buf)
            end
        end

        if vim.treesitter.language.add(lang) then
            start()
            return
        end

        if installing[lang] then
            table.insert(installing, start)
            return
        elseif vim.tbl_contains(ts.get_available(), lang) then
            installing[lang] = { start }
            ts.install({ lang }):await(function()
                vim.schedule(function()
                    for _, cb in ipairs(installing[lang]) do cb() end
                    installing[lang] = nil
                end)
            end)
        end
    end,
})
