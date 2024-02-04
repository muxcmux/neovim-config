return {
  'nvim-telescope/telescope.nvim',
  config = function()
    local actions = require('telescope.actions')
    require("telescope").setup({
      defaults = {
        selection_caret = " ",
        prompt_prefix = " ",
        mappings = {
          i = {
            ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
        },
      },

      pickers = {
        find_files = {
          -- find_command = { "rg", "--files", "--hidden" },
          find_command = { "fd", "--type", "file", "--follow", "--hidden", "--exclude", ".git" },
          -- theme = "ivy",
          previewer = false,
          layout_config = {
            height = 0.3,
          },
        },
        live_grep = {
          theme = "ivy",
          prompt_prefix = "󰍉 ",
          layout_config = {
            height = 0.5,
          },
        },
        grep_string = {
          theme = "ivy",
          prompt_prefix = "󰍉 ",
          layout_config = {
            height = 0.5,
          },
        },
        current_buffer_fuzzy_find = {
          theme = "ivy",
          prompt_prefix = "󰍉 ",
          layout_config = {
            height = 0.5,
          },
        },
        lsp_definitions = {
          theme = "dropdown",
          prompt_prefix = "ƒ ",
        },
        lsp_references = {
          theme = "dropdown",
          prompt_prefix = "ƒ ",
        },
        lsp_implementations = {
          theme = "dropdown",
          prompt_prefix = "ƒ ",
        },
        lsp_type_definitions = {
          theme = "dropdown",
          prompt_prefix = "ƒ ",
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        }
      }
    })

    require('telescope').load_extension('fzf')
  end,

  keys = {
    { "<leader>b", ":Telescope buffers<CR>", desc = "List buffers", silent = true },
    { "<leader>F", ":Telescope live_grep<CR>", desc = "Find in project", silent = true },
    { "<leader>s", ":Telescope grep_string<CR>", desc = "Find a string in project", silent = true },
    { "<leader>gc", ":Telescope git_branches<CR>", desc = "List git branches", silent = true },
    { "<leader>y", ":Telescope symbols<CR>", desc = "List symbols and emoji", silent = true },
    { "<leader>t", ":Telescope find_files<CR>", desc = "Find files", silent = true },
    { "<leader>l", ":Telescope help_tags<CR>", desc = "Find help tags", silent = true },
    { "<leader>s", [["ty:exec "Telescope live_grep default_text=". escape(@t, '<Space>()[]{}?.')<CR>]], desc = "Find a string in project", mode = "v", silent = true },
  },

  cmd = 'Telescope',

  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-tree/nvim-web-devicons",
    'nvim-telescope/telescope-symbols.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
}
