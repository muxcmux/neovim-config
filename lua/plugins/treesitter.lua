return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { "VeryLazy" },
    build = ":TSUpdate",
    opts = {
      -- ensure_installed = { "ruby", "lua", "rust", "javascript", "typescript", "css" },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = false
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = false,
          keymaps = {
            ["af"] = "@function.outer",
            ["am"] = "@function.outer",
            ["if"] = "@function.inner",
            ["im"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
          selection_modes = {
            ["@function.outer"] = 'V',
            ["@function.inner"] = 'V',
            ["@class.outer"] = 'V',
            ["@class.inner"] = 'V',
            ["@block.outer"] = 'V',
            ["@block.inner"] = 'V',
          },
          include_surrounding_whitespace = false,
        },
        swap = {
          enable = false,
        },
      },
      endwise = {
        enable = true,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  }, {
    'DariusCorvus/tree-sitter-surrealdb.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter'},
    ft = { 'rust', 'surql' },
    config = function()
      require('tree-sitter-surrealdb').setup()
    end,
  }
}

-- neovim 10
-- return {
--   {
--     'nvim-treesitter/nvim-treesitter',
--     branch = "main",
--     lazy = false,
--     build = ":TSUpdate",
--     config = function()
--       require("nvim-treesitter").setup({
--         auto_install = true,
--       })
--       -- how do we make sure that the event is the
--       -- last one to happen after openin a buffer????
--       -- vim.api.nvim_create_autocmd('BufWinEnter', {
--       --   pattern = { "*.rb", "*.c" },
--       --   callback = function()
--       --     vim.defer_fn(function()
--       --       vim.treesitter.start()
--       --     end, 5)
--       --   end,
--       -- })
--       vim.api.nvim_create_autocmd('FileType', {
--         pattern = {
--           "help",
--           "bash",
--           "c",
--           "cpp",
--           "css",
--           "dockerfile",
--           "erb",
--           "fish",
--           "go",
--           "html",
--           "htmldjango",
--           "javascript",
--           "json",
--           "lua",
--           "make",
--           "python",
--           "ruby",
--           "rust",
--           "shell",
--           "sql",
--           "surql",
--           "svg",
--           "toml",
--           "typescript",
--           "xml",
--           "yaml",
--         },
--         callback = function()
--           -- vim.defer_fn(function()
--             vim.treesitter.start()
--           -- end, 60)
--         end,
--       })
--     end,
--   }
-- }
