vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("CmtLsFiletype", { clear = true }),
  pattern = "Gemfile",
  callback = function()
    local root_dir = vim.fs.dirname(
      vim.fs.find({"Gemfile"}, { upward = true })[1]
    )
    local client = vim.lsp.start({
      name = "cmt",
      cmd = { "cargo", "run" },
      -- cmd = { "target/release/cmt_ls" },
      root_dir = root_dir,
    })
    vim.lsp.buf_attach_client(0, client)
  end
})
