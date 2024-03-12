return {
  {
    "echasnovski/mini.files",
    -- lazy = true,
    keys = {
      {
        "-",
        function()
          require("mini.files").open()
          require("mini.files").refresh { content = { filter = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end } }
        end,
        desc = "Open filetree",
        silent = true,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("mini.files").setup({
        mappings = {
          go_in_plus = "<CR>",
        },
      })

      local show_dotfiles = false

      local filter_show = function(_)
        return true
      end

      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh { content = { filter = new_filter } }
      end

      local open_in_vertical_split = function()
        local cur_entry_path = require("mini.files").get_fs_entry().path
        require("mini.files").close()
        vim.cmd("vnew" .. cur_entry_path)
      end

      local open_in_horizontal_split = function()
        local cur_entry_path = require("mini.files").get_fs_entry().path
        require("mini.files").close()
        vim.cmd("new" .. cur_entry_path)
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
          vim.keymap.set("n", "-", require("mini.files").close, { buffer = buf_id })
          vim.keymap.set("n", "<Esc>", require("mini.files").close, { buffer = buf_id })
          vim.keymap.set("n", "<C-v>", open_in_vertical_split)
          vim.keymap.set("n", "<C-x>", open_in_horizontal_split)
        end,
      })
    end
  }
}
