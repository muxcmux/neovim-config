return {
  'saecki/crates.nvim',
  event = { "BufRead Cargo.toml" },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('crates').setup({
      src = {
        cmp = { enabled = true }
      },
      lsp = {
        enabled = true,
        on_attach = function(_, bufnr)
          local opts = { silent = true, noremap = true, buffer = bufnr }
          vim.keymap.set('n', 'K', require("crates").show_popup, opts)
        end,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end,
}
