local function check_python_env()
    local venv_path = os.getenv("VIRTUAL_ENV") or ""
    local conda_path = os.getenv("CONDA_PREFIX") or ""
    local python_prog = vim.g.python3_host_prog or "Not set"

    local env_name = "None"
    local env_path = "None"

    if venv_path ~= "" then
        env_name = vim.fn.fnamemodify(venv_path, ":t") -- tên folder env
        env_path = venv_path
    elseif conda_path ~= "" then
        env_name = vim.fn.fnamemodify(conda_path, ":t")
        env_path = conda_path
    end

    local py_version = "Unknown"
    if python_prog ~= "Not set" then
        local handle = io.popen(python_prog .. " -c 'import sys; print(sys.version.split()[0])'")
        if handle then
            py_version = handle:read("*l") or "Unknown"
            handle:close()
        end
    end

    local width = 65
    local height = 10 
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
        border = "rounded"
    })

    local lines = {
        "Python Environment Info",
        "-------------------------------",
        "Env: " .. env_name,
        "Path: " .. env_path,
        "Python: " .. python_prog,
        "Version: " .. py_version,
    }

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf, noremap = true, silent = true })

    vim.keymap.set("n", "<Esc>", function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf, noremap = true, silent = true })
end

vim.api.nvim_create_user_command("CheckPythonEnv", check_python_env,
    { desc = "Show Python environment info in floating window" })
