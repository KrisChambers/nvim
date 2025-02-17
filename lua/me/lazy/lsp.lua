return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local function get_lspconfig()
            return require("lspconfig")
        end

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = false,
            ensure_installed = {
                "lua_ls",
                -- rust
                "rust_analyzer",
                -- python This is a wrapper around the one from Microsoft
                "pyright",
                -- terraform language servers
                "terraformls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
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
                    local lspconfig = require("lspconfig")

                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities
                    }

                    for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
                        local default_diagnostic_handler = vim.lsp.handlers[method]

                        -- NOTE (kc): There is a weird error where the lsp is canceling some request which causes some issues.
                        -- This wraps the handler and doesn't return an error for the diagnostics
                        vim.lsp.handlers[method] = function(err, result, context, config)
                            if err ~= nil and err.code == -32802 then
                                return
                            end
                            return default_diagnostic_handler(err, result, context, config)
                        end
                    end
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["terraformls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup({})
                end,

                ["jinja_lsp"] = function()
                    -- Need to recognize jinja filetypes
                    local jinja_filetype = 'jinja'
                    vim.filetype.add {
                        extension = {
                            jinja = jinja_filetype,
                            jinja2 = jinja_filetype,
                            j2 = jinja_filetype
                        }
                    }

                    local lspconfig = require('lspconfig')
                    lspconfig.jinja_lsp.setup {
                        capabilities = capabilities,
                    }
                end
            }
        })

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
}
