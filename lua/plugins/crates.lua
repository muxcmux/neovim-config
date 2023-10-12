return {
  'saecki/crates.nvim',
  event = { "BufRead Cargo.toml" },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      callback = function()
        local cmp = require("cmp")
        cmp.setup.buffer({ sources = { { name = "crates" } } })
      end,
    })
    require('crates').setup({
      src = {
        cmp = { enabled = true }
      }
    })
  end,
}
