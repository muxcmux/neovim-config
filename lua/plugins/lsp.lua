-- LSP Keymaps
local key = vim.keymap
local on_attach = function(_, bufnr)
  -- opens the diagnostics tooltip on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })

  -- keymaps
  local opts = { silent = true, noremap = true, buffer = bufnr }

  -- key.set("n", "gd", ":Trouble lsp_definitions<CR>", opts)
  key.set("n", "gd", vim.lsp.buf.definition, opts)
  key.set("n", "gr", vim.lsp.buf.references, opts)
  key.set("n", "gi", ":Trouble lsp_implementations<CR>", opts)
  key.set("n", "gt", ":Trouble lsp_type_definitions<CR>", opts)
  key.set("n", "<leader>d", ":Trouble document_diagnostics<CR>", opts)
  key.set("n", "<leader>wd", ":Trouble workspace_diagnostics<CR>", opts)
  key.set("n", "<leader>q", ":TroubleClose<CR>:cclose<CR>", opts)
  key.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
  key.set("n", "<leader>f",vim.lsp.buf.format, opts)
  key.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  key.set("n", "]g", vim.diagnostic.goto_next, opts)
  key.set("n", "[g", vim.diagnostic.goto_prev, opts)
  key.set("n", "K", vim.lsp.buf.hover, opts)
  key.set('n', '<space>K', vim.lsp.buf.signature_help, opts)
end

return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    -- configure the signs in the sign column and the virtual text
    local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
    end

    vim.diagnostic.config({
      virtual_text = false
    })

    ------------------------------
    -- LSP Server configuration --
    ------------------------------

    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local lspconfig = require("lspconfig")

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          runtime = {
            version = 'LuaJIT',
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            }
          }
        },
      },
    })

    -- Rust
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            allFeatures = true,
            overrideCommand = {
              'cargo', 'clippy', '--workspace', '--message-format=json',
              '--all-targets', '--all-features'
            }
          }
        }
      }
    })

    -- Ruby Solargraph
    lspconfig.solargraph.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        solargraph = {
          diagnostics = true,
          completion = true
        }
      }
    })

    -- Typescript
    lspconfig.tsserver.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Javascript/Typescript rust powered ls
    lspconfig.rome.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Eslint lsp
    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Json LSP config
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Tailwind
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Markdown and writing related lsps
    lspconfig.ltex.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.marksman.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Dockerfile LSP
    lspconfig.dockerls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,

  dependencies = {
    'folke/trouble.nvim',
    'b0o/schemastore.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'onsails/lspkind.nvim',
  }
}
