return {
    {
        "EdenEast/nightfox.nvim",
        config = function()
            -- Chọn theme Nightfox bạn muốn
            require("nightfox").setup({
                options = {
                    transparent = false, -- true nếu bạn muốn nền trong suốt
                    dim_inactive = true,
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                    },
                },
                palettes = {},
                groups = {},
            })

            -- Áp dụng theme Nightfox
            vim.cmd("colorscheme nightfox")
        end,
        lazy = false, -- tải ngay khi Neovim khởi động
    },
}
