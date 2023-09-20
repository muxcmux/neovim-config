return {
  'nvim-pack/nvim-spectre',
  keys = {
    { "<leader>S", ":lua require'spectre'.toggle()<CR>", desc = "Search and replace in project", silent = true },
    { "<leader>S", "<esc>:lua require'spectre'.open_visual()<CR>", desc = "Search and replace in project", silent = true, mode = "v" },
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
