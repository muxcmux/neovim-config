return {
  -- Automatically close paired brackets and quotes
  {
    'windwp/nvim-autopairs',
    event = { "VeryLazy" },
    opts = {
      check_ts = true,
      map_cr = true,
    },
  },

  -- Align stuff
  {
    'tommcdo/vim-lion',
    event = { "VeryLazy" },
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    event = { "VeryLazy" },
    opts = {},
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
