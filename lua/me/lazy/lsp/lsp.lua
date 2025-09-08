return {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        --"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
        --"hrsh7th/cmp-cmdline", "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip",
        --"saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim", "saghen/blink.cmp", },

    config = function()
        local function client_capabilities()
            local caps = vim.lsp.protocol.make_client_capabilities()

            -- This is turned off by default
            caps.workspace.didChangeWatchedFiles.dynamicRegistration = true

            return caps
        end

        --- @return lsp.ClientCapabilities
        local function get_blink_capabilities()
            local blk_caps = require("blink.cmp").get_lsp_capabilities()
            local client_caps = client_capabilities()

            return vim.tbl_deep_extend("force", {}, blk_caps, client_caps)
        end


        local lspconfig = require("lspconfig")


        -- BUG (kc): Haskell doesn't like these. Some issues with the importLens when inlay hints are enabled
        --         : TO reproduce this. turn on inlay hints, Create a new file and start typing.
        -- vim.lsp.inlay_hint.enable(true, {nil})

        local capabilities = get_blink_capabilities()

        require("fidget").setup({})
        require("mason").setup({})

        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            automatic_enable = false, -- We turn this off because lspconfig will enable the lsp when the setup runs
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
            },
        })

        -- Mason-lspconfig not longer handles the setups so here is an alternative setup that utilizes lspconfig
        -- Note (kc): When lspconfig.*.setup is called it looks like it does the vim.lsp.enable
        --            So doing this means we want the automatic_enable turned off otherwise we have seen duplicate entries
        --            in the type checking

        local function default_setup(server_name)
            lspconfig[server_name].setup {
                capabilities = capabilities
            }
        end

        local setup_handlers = {

            --["basedpyright"] = function()
            --    require('lspconfig').basedpyright.setup {
            --        on_attach = function()
            --            print("BASEDPYRIGHT ATTACHED")
            --        end,
            --        settings = {
            --            basedpyright = {
            --                analysis = {
            --                    autoSearchPaths = true,
            --                    useLibraryCodeForTypes = true,
            --                    typeCheckingMode = "standard",
            --                    diagnosticMode = "workspace",
            --                    disableOrganizeImports = true
            --                }
            --            },
            --            python = {
            --                analysis = {
            --                    ignore = { '*' }
            --                }
            --            }
            --        }
            --    }
            --end,

            ["pyright"] = function()
                lspconfig.pyright.setup {
                    on_attach = function()
                        print("PYRIGHT ATTACHED")
                    end,
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                typeCheckingMode = "standard",
                                diagnosticMode = "workspace",
                            }
                        }
                    }
                }
            end,
            ["yamlls"] = function ()
                require("lspconfig").yamlls.setup {
                  settings = {
                    yaml = {
                      schemas = {
                        -- Treats every yaml file as a kubernetes file -- not sure I want that.
                        [require('kubernetes').yamlls_schema()] = "*.yaml",

                        -- ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                        -- ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                        -- ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
                        -- ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                        -- ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                        -- ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
                      },
                    },
                  },
                }
            end
        }

        setmetatable(setup_handlers, {
            __index = function(_, key)
                return function()
                    default_setup(key)
                end
            end

        })

        local servers = mason_lspconfig.get_installed_servers()

        for _, value in ipairs(servers) do
            setup_handlers[value]()
        end


        --local handlers = {
        --     function(server_name) -- default handler (optional)
        --         lspconfig()[server_name].setup {
        --             capabilities = capabilities
        --         }
        --     end,

        --     ["rust_analyzer"] = function()
        --         lspconfig().rust_analyzer.setup({
        --             capabilities = capabilities,
        --         })
        --     end,

        --     ["lua_ls"] = function()
        --         lspconfig().lua_ls.setup {
        --             capabilities = capabilities,
        --             settings = {
        --                 Lua = {
        --                     runtime = { version = "Lua 5.1" },
        --                     diagnostics = {
        --                         globals = { "vim" },
        --                     },
        --                 }
        --             }
        --         }
        --     end,

        --     ["basedpyright"] = function()
        --         print('basedpyright setup')
        --         lspconfig().basedpyright.setup {
        --             capabilities = capabilities,
        --             settings = {
        --                 python = {
        --                     analysis = {
        --                         typeCheckingMode = "off",
        --                         diagnosticMode = "workspace"
        --                     }
        --                 }
        --             }
        --         }
        --     end,

        --     --           ["pyright"] = function()
        --     --               get_lspconfig().pyright.setup {
        --     --                   capabilities = capabilities,
        --     --               }
        --     --           end,

        --     ["terraformls"] = function()
        --         lspconfig().terraformls.setup {
        --             capabilities = capabilities,
        --         }
        --     end
        -- }
    end
}
