return {
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_show_views = 1
        end,

        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")

            -- configure manual  autocompletion
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    -- tab completion
                    ['<Tab>'] = cmp_lsp.tab_complete(),
                    ['<S-Tab>'] = cmp_lsp.select_prev_or_fallback(),
                })
            })

            -- autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"sql", "mysql", "plsql"},
                callback = function()
                    cmp.setup.buffer {
                        sources = {
                            { name = 'vim-dadbod-completion' }
                        }
                    }
                end,
            })

        end
    }
}
