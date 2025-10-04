return {
    -- Mason core
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Mason + LSP integration
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
            ensure_installed = { "pyright", "clangd", "tsserver", "lua_ls" },
        }
    },

    -- nvim-lspconfig

    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.g.python3_host_prog = vim.fn.exepath("python3")
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        pythonPath = vim.g.python3_host_prog,
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        }
                    }
                }
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern(
                    "compile_commands.json",
                    "compile_flags.txt",
                    ".git"
                )
            })
            lspconfig.cmake.setup {
                cmd = { "cmake-language-server" },
                filetypes = { "cmake" },
                init_options = {
                    buildDirectory = "build"
                },
                oot_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git")
            }

            lspconfig.lua_ls.setup({ capabilities = capabilities })
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

            vim.diagnostic.config({
                update_in_insert = true,
                virtual_text = {
                    prefix = "●", -- ký hiệu lỗi
                    spacing = 2,
                },
                float = {
                    border = "rounded",
                },
            })
        end,
    },

}
