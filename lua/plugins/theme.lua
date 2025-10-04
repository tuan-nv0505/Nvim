-- return {
--     {
--         "EdenEast/nightfox.nvim",
--         config = function()
--             -- Chọn theme Nightfox bạn muốn
--             require("nightfox").setup({
--                 options = {
--                     transparent = false, -- true nếu bạn muốn nền trong suốt
--                     dim_inactive = true,
--                     styles = {
--                         comments = "italic",
--                         keywords = "bold",
--                     },
--                 },
--                 palettes = {},
--                 groups = {},
--             })
--
--             -- Áp dụng theme Nightfox
--             vim.cmd("colorscheme nightfox")
--         end,
--         lazy = false, -- tải ngay khi Neovim khởi động
--     },
-- }



return {
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- load ngay (bỏ nếu bạn muốn lazy load)
        priority = 1000, -- cho nó load trước các plugin khác để màu apply đúng
        config = function()
            require("tokyonight").setup({
                -- style: "storm", "night", "day", "moon", "night" tùy thích
                style = "night",
                -- transparent background
                transparent = false,
                -- terminal colors
                terminal_colors = true,
                -- styles cho code (italic, bold...)
                styles = {
                    comments = { italic = true },
                    keywords = { italic = false, bold = false },
                    functions = { bold = false },
                    variables = {},
                },
                -- overrides nếu muốn tùy chỉnh highlight
                on_highlights = function(hl, c)
                    -- ví dụ: change CursorLine bg
                    hl.CursorLine = { bg = c.bg_highlight }
                end,
            })

            -- apply colorscheme
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
}
