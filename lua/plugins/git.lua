return {
  -- Displays git info in number column
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
    },
    keys = {
      { "<leader>hp", ":Gitsigns preview_hunk<CR>", desc = "Preview hunk", silent = true },
      { "<leader>hs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk", silent = true },
      { "<leader>hu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk", silent = true },
      { "<leader>hr", ":Gitsigns reset_hunk<CR>", desc = "Reset hunk", silent = true },
      { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle current line blame", silent = true },
    },
  },

  -- tpope, because he is awesome
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
}
