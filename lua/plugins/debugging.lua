-- file: lua/plugins/debugging.lua
-- Cấu hình nvim-dap cho Python và C++ với dap-ui

-- Đặt Python host trước khi lazy-load plugin
vim.g.python3_host_prog = vim.fn.exepath("python3")

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Setup dap-ui
        dapui.setup()

        ---------------------------
        -- Python configuration
        ---------------------------
        dap.adapters.python = {
            type = "executable",
            command = vim.g.python3_host_prog, -- dùng Python mà Neovim đang dùng
            args = { "-m", "debugpy.adapter" },
        }

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                console = "integratedTerminal",
                pythonPath = function()
                    return vim.g.python3_host_prog
                end,
            },
        }

        ---------------------------
        -- C++ configuration
        ---------------------------
        dap.adapters.lldb = {
            type = 'executable',
            command = '/usr/local/Cellar/llvm/21.1.1/bin/lldb-dap',
            name = 'lldb'
        }

        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                runInTerminal = true,
            },
        }

        dap.configurations.c = dap.configurations.cpp -- C dùng cùng config với C++

        ---------------------------
        -- Tự động mở/đóng dap-ui
        ---------------------------
        dap.listeners.before.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        ---------------------------
        -- Keymaps debug
        ---------------------------
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, opts)
        vim.keymap.set("n", "<Leader>dc", dap.continue, opts)
        vim.keymap.set("n", "<Leader>di", dap.step_into, opts)
        vim.keymap.set("n", "<Leader>do", dap.step_over, opts)
        vim.keymap.set("n", "<Leader>dO", dap.step_out, opts)
        vim.keymap.set("n", "<Leader>dr", dap.repl.open, opts)
        vim.keymap.set("n", "<Leader>dq", dap.terminate, opts)

        ---------------------------
        -- Build nhanh C++20 (tùy chọn)
        ---------------------------
        vim.keymap.set("n", "<Leader>cb", function()
            local file = vim.fn.expand("%")
            local output = vim.fn.expand("%:r")
            vim.cmd("!clang++ -std=c++20 -g " .. file .. " -o " .. output)
            print("Compiled: " .. output)
        end, opts)
    end,
}
