return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { "VeryLazy" },
    build = ":TSUpdate",
    opts = {
      -- ensure_installed = { "ruby", "lua", "rust", "javascript", "typescript", "css" },
      sync_install = false,
      auto_install = true,
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
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
          include_surrounding_whitespace = false,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>m"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>M"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  },
}
