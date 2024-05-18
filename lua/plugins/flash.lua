return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = { enabled = false },
      search = { enabled = false },
    },
  },
  keys = {
    { "s", mode = "n", function() require("flash").jump() end, desc = "Flash" },
  },
}
