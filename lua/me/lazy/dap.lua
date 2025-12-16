return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio",  "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap-python" },
        config = function()
            local dap, dapui, dap_python = require("dap"), require("dapui"), require("dap-python")
            -- Enable the virtual text commented out
            require("nvim-dap-virtual-text").setup({ commented = true, })
            dapui.setup({
                layouts = {
                    {
                        position=  "top",
                        size = 15,
                        elements = {
                            { id = "watches", size = 1 },
                        }
                    },
                    {
                        position = "left",
                        size = 40,
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                        }
                    },
                    {
                        position = "bottom",
                        size = 10,
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 }
                        }
                    }
                }
            })

            -- There is a "SetBreakPoint" and "SetExceptionBreakPoint".
            -- We want two types of flows:
            --  1. None -> BP -> EBP -> None : next_breakpoint
            --  2. None -> BP -> None : toggle_breakpoint
            dap_python.setup("uv")
            local set_cmd = vim.keymap.set

            local function start_debugger()
                local current_win = vim.api.nvim_get_current_win()
                local ok, nvim_tree_api = pcall(require, "nvim-tree.api")
                if ok then
                    nvim_tree_api.tree.close()
                end
                vim.api.nvim_set_current_win(current_win)

                dapui.open()
                dap.continue()
            end

            local function stop_debugging()
                local current_win = vim.api.nvim_get_current_win()
                if dap.session() ~= nil then
                    dap.terminate()
                end

                dapui.close()
                local ok, nvim_tree_api = pcall(require, "nvim-tree.api")
                if ok then
                    nvim_tree_api.tree.open()
                end
                -- Check: If we are in a dapui element when we run this then don't try and switch.
                vim.api.nvim_set_current_win(current_win)
            end

            vim.fn.sign_define("DapBreakpoint", {
                text = "&>",
                texthl = "DiagnosticSignError",
                linehl = "",
                numhl = "DiagnosticSignError"
            })

            vim.fn.sign_define("DapBreakpointRejected", {
                text = "x",
                texthl = "DiagnosticSignError",
                linehl = "",
                numhl = ""

            })

            vim.fn.sign_define("DapStopped", {
                text = "=>",
                texthl = "DiagnosticSignWarn",
                linehl = "Visual",
                numhl = "DiagnosticSignWarn"
            })

            local function dap_keymap(action, fallback)
                return function()
                    if dap.session() then
                        action()
                    elseif fallback then
                        fallback()
                    end
                end

            end

            set_cmd("n", "<leader>bp", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            set_cmd("n", "<leader>dap", start_debugger, { desc = "Start the debugger / Continue to next Breakpoint" })
            set_cmd("n", "<leader>cp", dap.clear_breakpoints, { desc = "Clear Breakpoints" })
            set_cmd("n", "<Down>", dap_keymap(dap.step_over, function() vim.cmd("normal! j") end), { desc = "Step Over" })
            set_cmd("n", "<Right>", dap_keymap(dap.step_into, function() vim.cmd("normal! l") end), { desc = "Step Into" })
            set_cmd("n", "<Left>", dap_keymap(dap.step_out, function () vim.cmd("normal! h") end), { desc = "Step Out" })
            set_cmd("n", "<Up>", dap_keymap(dap.restart_frame, function() vim.cmd("normal! k") end), { desc = "Restart Frame" })
            set_cmd("n", "<leader>dc", stop_debugging, { desc = "Stop Debugging" })
            set_cmd("n", "<leader>dm", dap_python.test_method, { desc = "Debug Test Method"})
            set_cmd("n", "<leader>dm", dap_python.test_class, { desc = "Debug Test Class"})


            dap.adapters.lldb = {
                type = "executable",
                command = "/usr/bin/lldb",
                name = "llbdb"
            }

            table.insert(dap.configurations.python, {
                type = "python",
                request = "launch",
                name = "Debug CLI (module)",
                module = function()
                    return vim.fn.input("Module name: ")
                end,
                args = function()
                    local input = vim.fn.input("Arguments: ")
                    if input == "" then return {} end
                    return vim.split(input, " ")
                end,
                console = "integratedTerminal",
                cwd = "${workspaceFolder}"
            })
        end
    },
    {
        "mfussenegger/nvim-dap",
    }
}
