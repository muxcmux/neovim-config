-- LSP Keymaps
local key = vim.keymap

local highlight_symbol_under_cursor = function(client, bufnr)
  if client.supports_method "textDocument/documentHighlight" then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local keymaps = function(bufnr)
  local opts = { silent = true, noremap = true, buffer = bufnr }

  key.set("n", "gd", vim.lsp.buf.definition, opts)
  key.set("n", "gr", vim.lsp.buf.references, opts)
  key.set("n", "gi", ":Trouble lsp_implementations<CR>", opts)
  key.set("n", "gt", ":Trouble lsp_type_definitions<CR>", opts)
  key.set("n", "<leader>e", ":Trouble document_diagnostics<CR>", opts)
  key.set("n", "<leader>we", ":Trouble workspace_diagnostics<CR>", opts)
  key.set("n", "<leader>q", ":TroubleClose<CR>:cclose<CR>", opts)
  key.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
  key.set("n", "<leader>f",vim.lsp.buf.format, opts)
  key.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  key.set("n", "]g", vim.diagnostic.goto_next, opts)
  key.set("n", "[g", vim.diagnostic.goto_prev, opts)
  key.set("n", "K", vim.lsp.buf.hover, opts)
  key.set('n', '<space>K', vim.lsp.buf.signature_help, opts)
end

local on_attach = function(client, bufnr)
  keymaps(bufnr)
  highlight_symbol_under_cursor(client, bufnr)
end

return {
  {
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
              globals = { "vim", "hs" },
            },
            runtime = {
              version = 'LuaJIT',
            },
            hint = {
              enable = true,
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
        capabilities = vim.tbl_deep_extend('force', capabilities, {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
              },
            },
          },
          experimental = {
            ssr = true,
            commands = {
              commands = {
                "rust-analyzer.runSingle",
                "rust-analyzer.debugSingle",
                "rust-analyzer.showReferences",
                "rust-analyzer.gotoLocation",
                "editor.action.triggerParameterHints",
              },
            },
          },
        }),
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

      -- Ruby
      lspconfig.ruby_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.solargraph.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          solargraph = {
            diagnostics = true,
            completion = true,
          }
        }
      })

      -- Typescript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Javascript/Typescript rust powered ls
      lspconfig.biome.setup({
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

      -- CSS
      lspconfig.cssls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Dockerfile LSP
      lspconfig.dockerls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- C/C++
      lspconfig.clangd.setup({
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
  }, {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          done_icon = "󰄭",
          progress_icon = {
            pattern = {"󱑖","󱑋","󱑌","󱑍","󱑎","󱑏","󱑐","󱑑","󱑒","󱑓","󱑔","󱑕"},
          },
        },
      },
    },
  }
}
