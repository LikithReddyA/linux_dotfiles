return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    "saghen/blink.cmp",
  },
  config = function()
    local keymap = vim.keymap -- for conciseness
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
      update_in_insert = false, -- avoid updating while typing
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("svelte", {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("eslint", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })
  end,
}

-- TODO: Need to review this and integrate the optimized one
-- optimized code of above config by chatgpt
-- File: lua/likith/core/lspconfig.lua
--
-- return {
--   "neovim/nvim-lspconfig",
--   event = { "BufReadPre", "BufNewFile" },
--   dependencies = {
--     { "antosha417/nvim-lsp-file-operations", config = true },
--     { "folke/neodev.nvim", opts = {} },
--     "saghen/blink.cmp",
--   },
--   config = function()
--     local lspconfig = require("lspconfig")
--     local keymap = vim.keymap
--     local capabilities = require("blink.cmp").get_lsp_capabilities()
--
--     -- -------------------------------
--     -- Diagnostics setup
--     -- -------------------------------
--     vim.diagnostic.config({
--       virtual_text = true,
--       signs = true,
--       underline = true,
--       update_in_insert = false,
--       severity_sort = true,
--       signs = {
--         text = {
--           [vim.diagnostic.severity.ERROR] = " ",
--           [vim.diagnostic.severity.WARN] = " ",
--           [vim.diagnostic.severity.HINT] = "󰠠 ",
--           [vim.diagnostic.severity.INFO] = " ",
--         },
--       },
--     })
--
--     -- -------------------------------
--     -- Reusable on_attach function
--     -- -------------------------------
--     local on_attach = function(client, bufnr)
--       -- Setup keymaps
--       local opts = { buffer = bufnr, silent = true }
--
--       keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
--       keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
--       keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
--       keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
--       keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
--       keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
--       keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--       keymap.set("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
--       keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
--       keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
--       keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
--       keymap.set("n", "K", vim.lsp.buf.hover, opts)
--       keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
--
--       -- Enable inlay hints if supported
--       if client.server_capabilities.inlayHintProvider then
--         vim.lsp.buf.inlay_hint(bufnr, true)
--       end
--
--       -- Java-specific setup for jdtls
--       if client.name == "jdtls" then
--         local jdtls = require("jdtls")
--         -- Optional: setup dap and keymaps for Java
--         if pcall(require, "jdtls.dap") then
--           require("jdtls.dap").setup_dap()
--           require("jdtls.dap").setup_dap_main_class_configs()
--         end
--         require("jdtls.setup").add_commands()
--       end
--     end
--
--     -- -------------------------------
--     -- LSP servers setup
--     -- -------------------------------
--
--     -- Lua (neovim config)
--     lspconfig.lua_ls.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = {
--         Lua = {
--           diagnostics = { globals = { "vim" } },
--           completion = { callSnippet = "Replace" },
--         },
--       },
--     })
--
--     -- Svelte
--     lspconfig.svelte.setup({
--       capabilities = capabilities,
--       on_attach = function(client, bufnr)
--         on_attach(client, bufnr)
--         vim.api.nvim_create_autocmd("BufWritePost", {
--           buffer = bufnr,
--           callback = function(ctx)
--             client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
--           end,
--         })
--       end,
--     })
--
--     -- GraphQL
--     lspconfig.graphql.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact", "svelte" },
--     })
--
--     -- Emmet
--     lspconfig.emmet_ls.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
--     })
--
--     -- ESLint
--     lspconfig.eslint.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
--     })
--
--     -- -------------------------------
--     -- Optional: generic setup for any other server
--     -- -------------------------------
--     local default_servers = { "tsserver", "pyright", "bashls", "jsonls", "yamlls" }
--     for _, server in ipairs(default_servers) do
--       lspconfig[server].setup({
--         capabilities = capabilities,
--         on_attach = on_attach,
--       })
--     end
--   end,
-- }
