-- ~/.config/nvim/lua/plugins/neo-tree.lua

-- Biến lưu trạng thái show/hide dotfiles
local show_dotfiles = true

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false,
        config = function()
            -- Keymap mở Neo-tree và reveal folder hiện tại
            vim.keymap.set("n", "<leader>v", ":Neotree filesystem reveal left<CR>", { desc = "Open Neo-tree" })

            -- Keymap toggle hiển thị file ẩn
            vim.keymap.set("n", "<leader>hd", function()
                show_dotfiles = not show_dotfiles
                require("neo-tree").setup({
                    filesystem = {
                        filtered_items = {
                            visible = true,
                            hide_dotfiles = not show_dotfiles,
                        }
                    }
                })
                require("neo-tree.sources.manager").refresh("filesystem", true)
                print(show_dotfiles and "Showing dotfiles" or "Hiding dotfiles")
            end, { desc = "Toggle hidden files in Neo-tree" })

            -- Cấu hình Neo-tree
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = true,                    -- hiện tất cả file bị filter
                        hide_dotfiles = not show_dotfiles, -- hiện file ẩn
                    },
                    follow_current_file = true,
                    use_libuv_file_watcher = true,
                },
                window = {
                    position = "left",
                    width = 40,
                },
                buffers = {
                    follow_current_file = true,
                },
                git_status = {
                    window = {
                        position = "float",
                    }
                },
            })

            -- Command toggle (tuỳ chọn)
            vim.api.nvim_create_user_command("NeoTreeToggleDotfiles", function()
                show_dotfiles = not show_dotfiles
                require("neo-tree").setup({
                    filesystem = {
                        filtered_items = {
                            visible = true,
                            hide_dotfiles = not show_dotfiles,
                        }
                    }
                })
                require("neo-tree.sources.manager").refresh("filesystem", true)
                print(show_dotfiles and "Showing dotfiles" or "Hiding dotfiles")
            end, { desc = "Toggle showing hidden files in Neo-tree" })
        end,
    }
}
