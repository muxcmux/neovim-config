return {
  -- Oil.nvim
  -- {
  --   'stevearc/oil.nvim',
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   lazy = false,
  --   opts = {
  --     skip_confirm_for_simple_edits = true,
  --   },
  --   keys = {
  --     { "-", ":Oil<CR>", desc = "Open parent dir for editing in a buffer", silent = true },
  --   },
  -- },
  {
    'echasnovski/mini.files',
    lazy = true,
    opts = {
      mappings = {
        go_in_plus = "<CR>",
      }
    },
    keys = {
      { "-", ":lua MiniFiles.open()<CR>", desc = "Open parent dir for editing in a buffer", silent = true },
    }
  }
}
