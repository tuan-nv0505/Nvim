-- pull lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.api.nvim_create_autocmd("TextChanged", {
    pattern = "*",
    command = "silent! write"
})

vim.lsp.enable("jdtls")
require("vim-options")
require("vim-helpers")
require("auto-save")
require("help-floating")
require("move-windows")
require("floating-terminal")
require("python-envs")
require("check-python-env")
require("lazy").setup("plugins", lazy_opts)
