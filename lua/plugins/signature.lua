return {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
        require("lsp_signature").setup({
            bind = true,
            handler_opts = {
                border = "rounded" -- khung popup
            },
            hint_enable = true, -- hiện gợi ý inline
            hint_prefix = "🐼 ", -- prefix cho vui, có thể đổi
            floating_window = true, -- popup hiển thị tham số
            floating_window_above_cur_line = true,
        })
    end,
}
