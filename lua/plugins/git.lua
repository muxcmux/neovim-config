return {
  -- Displays git info in number column
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
    },
    keys = {
      { "[g", ":Gitsigns prev_hunk<CR>", desc = "Previous hunk", silent = true },
      { "]g", ":Gitsigns next_hunk<CR>", desc = "Next hunk", silent = true },
      { "<leader>hp", ":Gitsigns preview_hunk<CR>", desc = "Preview hunk", silent = true },
      { "<leader>hs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk", silent = true },
      { "<leader>hu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk", silent = true },
      { "<leader>hr", ":Gitsigns reset_hunk<CR>", desc = "Reset hunk", silent = true },
      { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle current line blame", silent = true },
    },
  },

  -- tpope, because he is awesome
  {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    keys = {
      { "<leader>gv", ":Gvdiff!<CR>", desc = "Open 3-way vertical diff split", silent = true },
      { "<leader>gV", ":Gdiff!<CR>", desc = "Open 3-way diff split", silent = true },
      { "<leader>gh", ":diffget //2<CR>", desc = "Apply git changes from left (top)", silent = true },
      { "<leader>gl", ":diffget //3<CR>", desc = "Apply git changes from right (bottom)", silent = true },
    },
  },
  { 'tpope/vim-rhubarb' },
}
