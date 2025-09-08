return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio",  "mfussenegger/nvim-dap", },
        config = function()
            require("dapui").setup()
        end
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap, dapui= require("dap"), require("dapui")

            local set_cmd = vim.keymap.set

            local function start_debugger()
                dapui.open()
                dap.continue()
            end

            local function stop_debugging()
                if dap.session() ~= nil then
                    dap.terminate()
                end

                dapui.close()
            end

            -- You can setup temporary key maps using event listeners see :help dap-listeners

            -- set_cmd("n", "<leader>db", start_debugger, { desc = "Start the debugger / Continue to next Breakpoint" })
            -- set_cmd("n", "<leader>bp", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            -- set_cmd("n", "<leader>cp", dap.clear_breakpoints, { desc = "Clear Breakpoints" })
            -- set_cmd("n", "<Down>", dap.step_over, { desc = "Step Over" })
            -- set_cmd("n", "<Right>", dap.step_into, { desc = "Step Into" })
            -- set_cmd("n", "<Left>", dap.step_out, { desc = "Step Out" })
            -- set_cmd("n", "<Up>", dap.restart_frame, { desc = "Restart Frame" })
            -- set_cmd("n", "<leader>dbc", stop_debugging, { desc = "Stop Debugging" })


            -- Keymaps
            -- 1. Start debugger dbg (continue())
            -- 2. Step out dbk
            -- 3. Step into dbl
            -- 4. step over dbj
            -- 5. ClearBreakPoint dbh
            -- 7. ToggleBreakpoint dbp

            dap.adapters.lldb = {
                type = "executable",
                command = "/usr/bin/lldb",
                name = "llbdb"
            }

            dap.configurations.odin = {{
                name = "Launch LLDB",
                type = "lldb",
                request = "launch",
                program = function ()
                    return vim.fn.getcwd() .. "debug"
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            }}
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require('dap-python').setup("uv")
        end
    }
}
