return {
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Jump to the next slot on snippets
      vim.keymap.set({"i", "s"}, "<C-k>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end)

      -- Fix autopairs enter
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')

      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      return {
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer', keyword_length = 5, max_item_count = 10 },
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          -- ["<C-j>"] = cmp.mapping.select_next_item(),
          -- ["<C-k>"] = cmp.mapping.select_prev_item(),
          -- ["<C-n>"] = cmp.mapping.scroll_docs(4),
          -- ["<C-p>"] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        },
        formatting = {
          format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
            ellipsis_char = "…",
            menu = {
              buffer = "[buf]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[api]",
              path = "[path]",
              luasnip = "[snip]",
            },
          })
        },
      }
    end,
    dependencies = {
      'windwp/nvim-autopairs',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'onsails/lspkind.nvim',
      'saadparwaiz1/cmp_luasnip',
      {
        "L3MON4D3/LuaSnip",
        build = (not jit.os:find("Windows"))
            and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
          or nil,
        dependencies = {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        -- stylua: ignore
        -- keys = {
        --   {
        --     "<tab>",
        --     function()
        --       return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        --     end,
        --     expr = true, silent = true, mode = "i",
        --   },
        --   { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
        --   { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        -- },
      },
    },
  },
}
