local state = { floating = { buf = -1, win = -1 } }
local function create_floating_window_center(opts)
    opts = opts or {}
    local width = math.floor(vim.o.columns * 0.5)
    local height = math.floor(vim.o.lines * 0.5)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local config = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    }
    vim.api.nvim_set_hl(0, "MyFloatingWindow", { bg = "#1e1e1e", fg = "#ffffff", blend = 10 })
    local win = vim.api.nvim_open_win(buf, true, config)
    return { buf = buf, win = win }
end

local toggle_term_center = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window_center { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

local function create_floating_window_bottom(opts)
    opts = opts or {}
    local width = math.floor(vim.o.columns)
    local height = math.floor(vim.o.lines * 0.2)

    local row = math.floor(vim.o.lines)
    local col = vim.o.columns - width

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local config = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    }
    vim.api.nvim_set_hl(0, "MyFloatingWindow", { bg = "#1e1e1e", fg = "#ffffff", blend = 10 })
    local win = vim.api.nvim_open_win(buf, true, config)
    return { buf = buf, win = win }
end

local toggle_term_bottom = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window_bottom { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end


vim.api.nvim_create_user_command("FTerminal", toggle_term_center, {})
vim.keymap.set({ "n", "t" }, "<leader>T", toggle_term_center)
vim.api.nvim_create_user_command("FTerminalB", toggle_term_bottom, {})
vim.keymap.set({ "n", "t" }, "<leader>TT", toggle_term_bottom)
