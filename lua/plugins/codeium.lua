return {
  {
    'Exafunction/codeium.vim',
    event = "BufEnter",
    config = function()
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        TelescopeResults = false,
        minifiles = false,
      }
      vim.keymap.set('i', '<C-f>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-n>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-p>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-d>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },
}
