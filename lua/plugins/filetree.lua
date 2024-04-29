local show_dotfiles = false

local filter_show = function(_)
  return true
end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

local new_filter = function()
  return show_dotfiles and filter_show or filter_hide
end

return {
  {
    "echasnovski/mini.files",
    keys = {
      {
        "-",
        function()
          local mf = require("mini.files")
          mf.open(vim.api.nvim_buf_get_name(0))
          mf.refresh({
            content = {
              filter = new_filter()
            }
          })
        end,
        desc = "Open filetree",
        silent = true,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local mf = require("mini.files")
      mf.setup({
        mappings = {
          go_in_plus = "<CR>",
        },
      })

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        mf.refresh { content = { filter = new_filter() } }
      end

      local open_in_vertical_split = function()
        local cur_entry_path = mf.get_fs_entry().path
        mf.close()
        vim.cmd("vnew" .. cur_entry_path)
      end

      local open_in_horizontal_split = function()
        local cur_entry_path = mf.get_fs_entry().path
        mf.close()
        vim.cmd("new" .. cur_entry_path)
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
          vim.keymap.set("n", "-", mf.close, { buffer = buf_id })
          vim.keymap.set("n", "<Esc>", mf.close, { buffer = buf_id })
          vim.keymap.set("n", "<C-v>", open_in_vertical_split, { buffer = buf_id })
          vim.keymap.set("n", "<C-x>", open_in_horizontal_split, { buffer = buf_id })
        end,
      })
    end
  }
}
