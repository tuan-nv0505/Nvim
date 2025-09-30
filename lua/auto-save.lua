local M = {}

local ignore_filetypes = {
    "gitcommit", -- vẫn bỏ qua commit message
    "markdown",  -- optional
}

local function should_save()
    local ft = vim.bo.filetype
    for _, v in ipairs(ignore_filetypes) do
        if ft == v then
            return false
        end
    end
    return vim.bo.modifiable and vim.bo.readonly == false
end

local function save_buffer()
    if should_save() and vim.bo.modified then
        vim.cmd("silent! write")
        vim.notify("AutoSave: " .. vim.fn.expand("%:t"), vim.log.levels.INFO, { title = "Neovim" })
    end
end

function M.setup()
    vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "TextChanged" }, {
        pattern = "*",
        callback = save_buffer,
    })
end

M.setup()
return M
