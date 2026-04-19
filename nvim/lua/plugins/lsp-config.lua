return {
    { 
    "mason-org/mason.nvim",
     config = function ()
        require ("mason").setup()
     end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function ()
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls","pyright","clangd","ts_ls","cssls"} -- add lsp
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function ()
            local lspconfig = require ("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})
            lspconfig.clangd.setup({})
            lspconfig.ts_ls.setup({})
            lspconfig.cssls.setup({})

            vim.keymap.set('n', 'k', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set({'n', 'v'},'<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to implementation" })
        end
    }
}
