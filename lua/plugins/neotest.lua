return {
  {
    'nvim-neotest/neotest',
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-minitest'),
          require('neotest-rspec'),
        },
        icons = {
          running_animated = { "󱑖", "󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕" },
        },
      })
    end,
    lazy = true,
    cmd = { "Neotest summary toggle", "Neotest output-panel toggle", "Neotest run" },
    keys = {
      { "<leader>rs", ":Neotest summary toggle<CR>", desc = "Toggle test sidebar", silent = true },
      { "<leader>ro", ":Neotest output-panel toggle<CR>", desc = "Toggle test output panel", silent = true },
      { "<leader>rr", ":Neotest run<CR>", desc = "Run closest test", silent = true },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      -- adapters
      "olimorris/neotest-rspec",
      "zidhuss/neotest-minitest",
    },
  },
}
