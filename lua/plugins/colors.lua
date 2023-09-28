local function light()
  vim.api.nvim_set_option("background", "light")
  vim.cmd("colorscheme catppuccin-latte")
end

local function dark()
  vim.api.nvim_set_option("background", "dark")
  vim.cmd("colorscheme kanagawa")
end

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = {
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        }
      }
    },
  }, {
    "catppuccin/nvim",
    lazy = true,
  }, {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 1000,
      set_dark_mode = dark,
      set_light_mode = light,
    },
    config = function(_, opts)
      local adm = require("auto-dark-mode")
      if string.find(vim.fn.system('defaults read -g AppleInterfaceStyle'), "Dark") then
        dark()
      else
        light()
      end

      adm.setup(opts)
    end
  }
}
