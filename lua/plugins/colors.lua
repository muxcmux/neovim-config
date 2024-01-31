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

-- local function extend_hl(name, options)
--   local existing = vim.api.nvim_get_hl(0, { name = name })
--   vim.api.nvim_set_hl(0, name, vim.tbl_deep_extend("force", existing, options))
-- end

return {
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require("transparent").setup({
        exclude_groups = { "StatusLine" },
      })
      -- highlight groups
      -- local diff_add = vim.api.nvim_get_hl(0, { name = "DiffAdd" })
      -- local diff_delete = vim.api.nvim_get_hl(0, { name = "DiffDelete" })
      -- local diff_change = vim.api.nvim_get_hl(0, { name = "DiffChange" })

      -- vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = diff_add.bg, bg = "none"})
      -- vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = diff_delete.bg, bg = "none"})
      -- vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = diff_change.bg, bg = "none"})

      -- extend_hl('DiagnosticUnderlineError', { undercurl = true })
      -- extend_hl('DiagnosticUnderlineInfo', { undercurl = true })
      -- extend_hl('DiagnosticUnderlineHint', { undercurl = true })
      -- extend_hl('DiagnosticUnderlineWarn', { undercurl = true })
    end,
  }, {
    'mcchrish/zenbones.nvim',
    lazy = false,
    branch = "main",
    config = function()
      -- if string.find(vim.fn.system('defaults read -g AppleInterfaceStyle'), "Dark") then
      --   vim.cmd("set bg=dark")
      --   vim.cmd("colorscheme kanagawabones")
      -- else
      --   vim.cmd("set bg=light")
      --   vim.cmd("colorscheme zenbones")
      -- end

      vim.cmd("colorscheme randombones")
      vim.opt.termguicolors  = true

      vim.keymap.set("n", "<leader>z", function()
        vim.cmd("colorscheme randombones")
        print(vim.g.randombones_colors_name)
      end, { silent = true })

      print(vim.g.randombones_colors_name)
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
