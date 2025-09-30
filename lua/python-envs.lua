-- lua/python_selector.lua
local M = {}

-- State floating window
local state = { buf = -1, win = -1 }

-- Tạo floating window giữa màn hình
local function create_floating_window()
    local width = math.min(math.floor(vim.o.columns * 0.6), 80)
    local height = math.min(math.floor(vim.o.lines * 0.5), 20)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_win_set_option(win, "cursorline", true)
    vim.api.nvim_set_hl(0, "MyFloatingWindow", { bg = "#1e1e1e", fg = "#ffffff", blend = 10 })

    return buf, win
end

-- Tìm Python interpreters: venv, conda, hệ thống
local function find_interpreters()
    local interpreters = {}
    local Path = require("plenary.path")
    local cwd = vim.fn.getcwd()
    local folders = { ".venv", "venv", "env" }

    -- venv trong project
    for _, folder in ipairs(folders) do
        local p = Path:new(cwd, folder, "bin", "python")
        if vim.fn.filereadable(p:absolute()) == 1 then
            table.insert(interpreters, p:absolute())
        end
    end

    -- Conda env
    local handle = io.popen("conda env list --json 2>/dev/null")
    if handle then
        local json = handle:read("*a")
        handle:close()
        local ok, data = pcall(vim.fn.json_decode, json)
        if ok and data.envs then
            for _, path in ipairs(data.envs) do
                local py = path .. "/bin/python"
                if vim.fn.filereadable(py) == 1 then
                    table.insert(interpreters, py)
                end
            end
        end
    end

    -- Python mặc định hệ thống
    local sys_py = vim.fn.exepath("python3")
    if sys_py ~= "" then
        table.insert(interpreters, sys_py)
    end

    return interpreters
end
-- Hiển thị floating window, chọn interpreter
function M.select_python_floating()
    local interpreters = find_interpreters()
    if #interpreters == 0 then
        print("No Python interpreters found!")
        return
    end

    local buf, win = create_floating_window()
    state.buf = buf
    state.win = win

    local lines = {}
    for i, interp in ipairs(interpreters) do
        table.insert(lines, string.format("[%d] %s", i, interp))
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)

    -- Close window helper
    local function close_win()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- Keymaps
    vim.keymap.set("n", "j", "j", { buffer = buf, noremap = true })
    vim.keymap.set("n", "k", "k", { buffer = buf, noremap = true })

    vim.keymap.set("n", "<CR>", function()
        local line_nr = vim.api.nvim_win_get_cursor(0)[1]
        local py = interpreters[line_nr]
        if py then
            vim.g.python3_host_prog = py
            print("Selected Python: " .. py)

            -- Restart pyright if running
            local ok, lspconfig = pcall(require, "lspconfig")
            if ok then
                for _, client in ipairs(vim.lsp.get_active_clients()) do
                    if client.name == "pyright" then
                        client.stop()
                    end
                end
                lspconfig.pyright.setup {
                    settings = { python = { pythonPath = py } },
                }
                print("Pyright restarted with new pythonPath")
            end
        end
        close_win()
    end, { buffer = buf, noremap = true, silent = true })

    vim.keymap.set("n", "q", close_win, { buffer = buf, noremap = true, silent = true })

    print("Use j/k to move, Enter to select, q to quit")
end

-- Keymap và command
vim.keymap.set("n", "<leader>sp", M.select_python_floating, { desc = "Select Python interpreter" })
vim.api.nvim_create_user_command("SelectPython", M.select_python_floating,
    { desc = "Select Python interpreter" })

return M



















