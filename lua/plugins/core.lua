return {
  -- Automatically close paired brackets and quotes
  -- {
  --   'altermo/ultimate-autopair.nvim',
  --   event = { "InsertEnter" },
  --   config = function()
  --     require('ultimate-autopair').setup({
  --       cmap = false,
  --       pair_cmap = false,
  --     })
  --   end
  -- },
  {
    'echasnovski/mini.pairs',
    config = function()
      require('mini.pairs').setup()
    end,
  },

  -- Align stuff
  {
    'tommcdo/vim-lion',
    event = { "VeryLazy" },
  },

  -- Switch between camelCase, TitleCase, snake_case, etc.
  {
    'arthurxavierx/vim-caser',
    event = { "VeryLazy"},
  },

  -- tpope, because he is awesome
  {
    'tpope/vim-surround',
    event = { "VeryLazy" },
  },
  {
    'tpope/vim-repeat',
    event = { "VeryLazy" },
  },
}
