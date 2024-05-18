return {
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require("transparent").setup({
        exclude_groups = { "StatusLine" },
      })
    end,
  }, {
    'muxcmux/zenbones.nvim',
    lazy = false,
    branch = "main",
    config = function()
      vim.cmd("colorscheme randombones")
      vim.opt.termguicolors  = true

      vim.keymap.set("n", "<leader>z", function()
        vim.cmd("colorscheme randombones")
        print(vim.g.randombones_colors_name)
      end, { silent = true })

      vim.schedule(function() print(vim.g.randombones_colors_name) end)
    end,
    dependencies = {
      'rktjmp/lush.nvim'
    }
  },
}
