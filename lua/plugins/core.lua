return {
  -- Automatically close paired brackets and quotes
  {
    'windwp/nvim-autopairs',
    event = { "InsertEnter" },
    opts = {
      check_ts = true,
      map_cr = true,
    },
  },

  -- Align stuff
  {
    'tommcdo/vim-lion',
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- tpope, because he is awesome
  {
    'tpope/vim-surround',
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    'tpope/vim-repeat',
    event = { "BufReadPost", "BufNewFile" },
  },
}
