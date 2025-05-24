return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        --"hrsh7th/cmp-nvim-lsp",
        --"hrsh7th/cmp-buffer",
        --"hrsh7th/cmp-path",
        --"hrsh7th/cmp-cmdline",
        --"hrsh7th/nvim-cmp",
        --"L3MON4D3/LuaSnip",
        --"saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "saghen/blink.cmp",
    },

    config = function()
        local function get_nvim_cmp_capabilities()
            local cmp_lsp = require("cmp_nvim_lsp")

            return vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())
        end

        local function get_blink_capabilities()
            local blk = require("blink.cmp")

            return vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                blk.get_lsp_capabilities())
        end

        -- Old setup for nvim-cmp
        local function setup_cmp()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

        end

        local function get_lspconfig()
            return require("lspconfig")
        end


        local capabilities = get_blink_capabilities()
        --local capabilities = get_nvim_cmp_capabilities()

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = false,
            automatic_enable = true,
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "pyright",
                "terraformls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    get_lspconfig()[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["hls"] = function()
                    get_lspconfig().hls.setup {
                        capabilities = capabilities,
                        filetypes = { 'haskell', 'lhaskell', 'cabal' }
                    }
                end,

                ["rust_analyzer"] = function()
                    get_lspconfig().rust_analyzer.setup({
                        capabilities = capabilities
                    })
                    -- We want inlay hints.
                    vim.lsp.inlay_hint.enable(true, {nil})

                    --for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
                    --    local default_diagnostic_handler = vim.lsp.handlers[method]

                    --    -- NOTE (kc): There is a weird error where the lsp is canceling some request which causes some issues.
                    --    -- This wraps the handler and doesn't return an error for the diagnostics
                    --    vim.lsp.handlers[method] = function(err, result, context, config)
                    --        if err ~= nil and err.code == -32802 then
                    --            return
                    --        end
                    --        return default_diagnostic_handler(err, result, context, config)
                    --    end
                    --end
                end,

                ["lua_ls"] = function()
                    get_lspconfig().lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = {  "vim" },
                                },
                            }
                        }
                    }
                end,

                ["terraformls"] = function()
                    get_lspconfig().terraformls.setup({})
                end
            }
        })

        --setup_cmp()
    end
}
