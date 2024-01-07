-- return {
--   {
--     'rose-pine/neovim',
--     name = 'rose-pine',
--     config = function()
--       require("rose-pine").setup();
--       vim.cmd("colorscheme rose-pine")
--     end,
--   }
-- }

return {
  {
    'mcchrish/zenbones.nvim',
    lazy = false,
    config = function()
      if string.find(vim.fn.system('defaults read -g AppleInterfaceStyle'), "Dark") then
        vim.cmd("set bg=dark")
        vim.cmd("colorscheme kanagawabones")
      else
        vim.cmd("set bg=light")
        vim.cmd("colorscheme zenbones")
      end
    end,
    dependencies = {
      'rktjmp/lush.nvim'
    }
  },
}

-- local function light()
--   vim.api.nvim_set_option("background", "light")
--   vim.cmd("colorscheme catppuccin-latte")
-- end

-- local function dark()
--   vim.api.nvim_set_option("background", "dark")
--   vim.cmd("colorscheme kanagawa")
-- end

-- return {
--   {
--     "rebelot/kanagawa.nvim",
--     lazy = true,
--     config = {
--       compile = true,
--       overrides = function(colors)
--         local theme = colors.theme
--         return {
--             Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
--             PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
--             PmenuSbar = { bg = theme.ui.bg_m1 },
--             PmenuThumb = { bg = theme.ui.bg_p2 },
--             WinSeparator = { fg = theme.ui.whitespace },
--         }
--     end,
--       colors = {
--         theme = {
--           all = {
--             ui = {
--               bg_gutter = "none"
--             }
--           }
--         }
--       }
--     },
--   }, {
--     "catppuccin/nvim",
--     lazy = true,
--     opts = {
--       integrations = {
--         neotest = true,
--         neotree = true,
--         mason = true,
--         lsp_trouble = true,
--         native_lsp = {
--           inlay_hints = {
--             background = false,
--           },
--         },
--       },
--       highlight_overrides = {
--         latte = function(colors)
--           return {
--             WinSeparator = { fg = colors.blue },
--           }
--         end,
--       },
--     },
--     config = function(_, opts)
--       require("catppuccin").setup(opts)
--     end
--   }, {
--     "f-person/auto-dark-mode.nvim",
--     lazy = false,
--     opts = {
--       update_interval = 1000,
--       set_dark_mode = dark,
--       set_light_mode = light,
--     },
--     config = function(_, opts)
--       local adm = require("auto-dark-mode")
--       if string.find(vim.fn.system('defaults read -g AppleInterfaceStyle'), "Dark") then
--         dark()
--       else
--         light()
--       end

--       adm.setup(opts)
--     end
--   }
-- }
