-- configure the signs in the sign column and the virtual text
-- local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
-- end

-- general diagnostics configuration
vim.diagnostic.config({
  signs = false,
  virtual_text = {
    format = function(diag)
      return vim.split(diag.message, "\n")[1]
    end,
  },
})

-- LSP Keymaps
local keymaps = function(bufnr)
  local opts = { silent = true, noremap = true, buffer = bufnr }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gi", ":Trouble lsp_implementations<CR>", opts)
  vim.keymap.set("n", "gt", ":Trouble lsp_type_definitions<CR>", opts)
  vim.keymap.set("n", "<leader>f",vim.lsp.buf.format, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, opts)
end

local highlight_symbol_under_cursor = function(client, bufnr)
  if client.supports_method("textDocument/documentHighlight") and client.server_capabilities.documentHighlightProvider then
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

local on_attach = function(client, bufnr)
  keymaps(bufnr)
  highlight_symbol_under_cursor(client, bufnr)
end

-- Because  is fucking special
-- decide which LSP to start based on some heuristics
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("RubyLsFiletype", { clear = true }),
  pattern = { "Gemfile", "Rakefile", "*.rb" },
  callback = function()
    local gemfile = vim.fs.find("Gemfile", { upward = true })[1]
    if gemfile then
      vim.cmd("LspStart ruby_ls")
      vim.fn.jobstart({ "rg", "standard", "Gemfile" }, {
        cwd = vim.fs.dirname(gemfile),
        on_exit = function(_, code)
          if code == 0 then
            vim.cmd("LspStart standardrb")
          else
            vim.fn.jobstart({ "rg", "rubocop", "Gemfile" }, {
              cwd = vim.fs.dirname(gemfile),
              on_exit = function(_, c)
                if c == 0 then
                  vim.cmd("LspStart rubocop")
                end
              end,
            })
          end
        end
      })
    else
      vim.cmd("LspStart standardrb")
    end
  end
})

return {
  {
    'neovim/nvim-lspconfig',
    -- event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspStart" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

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
        autostart = false,
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = {
          ["textDocument/diagnostic"] = function() end,
          ["textDocument/documentHighlight"] = function() end,
        }
      })

      lspconfig.standardrb.setup({
        autostart = false,
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.rubocop.setup({
        autostart = false,
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
      'linrongbin16/lsp-progress.nvim',
    },
  },
}
