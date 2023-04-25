return {
  -- Neotree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>\\", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      enable_diagnostics = false,
      popup_border_style = "single", -- "double", "none", "rounded", "shadow", "single" or "solid"
      use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
      default_component_configs = {
        icon = {
          folder_empty = ""
        },
        git_status = {
          symbols = {
            -- Change type
            -- added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
            -- deleted   = "✖",
            -- modified  = "",
            -- renamed   = "",
            added     = "", -- NOTE: you can set any of these to an empty string to not show them
            deleted   = "",
            modified  = "",
            renamed   = "",
            -- Status type
            -- untracked = "",
            -- ignored   = "",
            -- unstaged  = "",
            -- staged    = "",
            -- conflict  = "",
          },
        },
      },
      window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
        mappings = {
          ["<cr>"] = "open_drop",
          ["t"] = "open_tab_drop",
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["u"] = "navigate_up",
          }
        },
        follow_current_file = true, -- This will find and focus the file in the active buffer every time
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
                                       -- instead of relying on nvim autocmd events.
      },
      buffers = {
        window = {
          mappings = {
            ["u"] = "navigate_up",
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
}
