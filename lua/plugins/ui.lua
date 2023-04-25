return {
  {
    'hood/popui.nvim',
    evelt = "VeryLazy",
    config = function ()
      vim.g.popui_border_style = "rounded"
      vim.ui.select = require"popui.ui-overrider"
      vim.ui.input = require"popui.input-overrider"
    end
  },
}
