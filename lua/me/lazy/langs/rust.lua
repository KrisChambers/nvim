-- return {}
return {
    'mrcjkb/rustaceanvim',
    version = '^9', -- Recommended

    config = function()
        vim.g.rustaceanvim = function()
            print("running")
            return {
                server = {
                    on_attach = function(client, bufnr)
                        vim.keymap.set('n', '<leader>a',  function() vim.cmd.RustLsp 'codeAction' end, { buffer = bufnr })
                        vim.keymap.set('n', 'K',          function() vim.cmd.RustLsp { 'hover', 'actions' } end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>e',  function() vim.cmd.RustLsp 'expandMacro' end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>d',  function() vim.cmd.RustLsp 'debuggables' end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>r',  function() vim.cmd.RustLsp 'runnables' end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>t',  function() vim.cmd.RustLsp 'testables' end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>m',  function() vim.cmd.RustLsp { 'view', 'mir' } end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>h',  function() vim.cmd.RustLsp { 'view', 'hir' } end, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>c',  function() vim.cmd.RustLsp 'explainError' end, { buffer = bufnr })
                    end,
                    default_settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = true,
                            rustfmt = { enable = true },
                        },
                    }
                },
                dap = {
                    autoload_configurations = true
                }
            }
        end
    end

}
