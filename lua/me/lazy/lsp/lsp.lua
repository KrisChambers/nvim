return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        -- "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        "saghen/blink.cmp",
    },

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


        -- local lspconfig = require("lspconfig")



        -- BUG (kc): Haskell doesn't like these. Some issues with the importLens when inlay hints are enabled
        --         : TO reproduce this. turn on inlay hints, Create a new file and start typing.
        -- vim.lsp.inlay_hint.enable(true, {nil})

        local capabilities = get_blink_capabilities()

        require("fidget").setup({})
        require("mason").setup({})

        -- local mason_lspconfig = require("mason-lspconfig")
        -- mason_lspconfig.setup({
        --     automatic_enable = false, -- We turn this off because lspconfig will enable the lsp when the setup runs
        --     ensure_installed = {
        --         "lua_ls",
        --         "rust_analyzer",
        --     },
        -- })

        -- Mason-lspconfig not longer handles the setups so here is an alternative setup that utilizes lspconfig
        -- Note (kc): When lspconfig.*.setup is called it looks like it does the vim.lsp.enable
        --            So doing this means we want the automatic_enable turned off otherwise we have seen duplicate entries
        --            in the type checking



        local lsps = {
            {
                "lua_ls",
                {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME, -- for neovim
                                }
                            },
                        },
                    },
                }
            },
--             {
--                 "ty",
--                 { capabilities = capabilities }
--             },
            {
                "pyright",
                {
                    capabilities = capabilities,
                    settings = {
                        pyright = {
                            -- We want to use ruff for import organization
                            disableOrganizeImports = true
                        },
                        python = {
                            analysis = {
                                -- Only use ruff for linting
                                ignore = { "*" },
                            }
                        }
                    }
                }
            },

            {
                "ruff",
                {
                    capabilities = capabilities
                }

            },

            {
                "yamlls",
                {
                    capabilities = capabilities,
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
                    }
                }
            },

            {
                "rust_analyzer",
                {
                    capabilities = capabilities,
                    settings = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = "clippy", -- or "check" if you prefer
                        },
                    }
                }
            },

            {
                "hls",
                {
                    capabilities = capabilities,
                --     cmd = { 'haskell-language-server-wrapper', '--lsp' },
                    filetypes = { 'haskell', 'lhaskell' },
                --     root_dir = function(bufnr, on_dir)
                --         local fname = vim.api.nvim_buf_get_name(bufnr)
                --         on_dir(util.root_pattern('hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml')(fname))
                --     end,
                    settings = {
                        haskell = {
                            formattingProvider = 'fourmolu',
                            cabalFormattingProvider = 'cabal-fmt',
                        },
                    },
                }
            }
        }

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup('lsp_attach_and_disable_ruff_hover', {}),
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client == nil then
                return
              end
              if client.name == 'ruff' then
                client.server_capabilities.hoverProvider = false
              end
            end,
            desc = 'LSP: Disable hover capability from Ruff',
        })

        -- Defaults
        vim.lsp.config("*", {
            capabilities = capabilities
        })

        for _, lsp in pairs(lsps) do
            local name, config = lsp[1], lsp[2]

            vim.lsp.enable(name)
            if config ~= nil then
                vim.lsp.config(name, config)
            end

            -- registry.refresh(function()
            --     local installed = registry.get_installed_package_names()

            --     for _, name in ipairs(installed) do
            --         vim.lsp.enable(name)
            --         if server_name == name and config ~= nil then
            --             vim.lsp.config(name, config)
            --         end
            --     end
            -- end)
        end

    end
}
