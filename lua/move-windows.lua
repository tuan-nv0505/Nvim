-- Di chuyển giữa các khung bằng Ctrl + h/j/k/l
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set("n", "<A-Left>",  ":vertical resize -5<CR>")
vim.keymap.set("n", "<A-Right>", ":vertical resize +5<CR>")
vim.keymap.set("n", "<A-Up>",    ":resize +2<CR>")
vim.keymap.set("n", "<A-Down>",  ":resize -2<CR>")
