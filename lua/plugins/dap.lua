return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    keys = {
      { "<leader>db", ":lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle breakpoint", silent = true },
      { "<leader>dc", ":lua require'dap'.continue()<cr>", desc = "Debugger continue", silent = true },
      { "<leader>dr", ":lua require'dap'.repl.open()<cr>:wincmd j<cr>i", desc = "Open debugger repl", silent = true },
    },
    dependencies = {
      'rcarriga/cmp-dap',
      'LiadOz/nvim-dap-repl-highlights',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim',
    },
    config = function()
      local dap = require('dap')
      local codelldb = require("mason-registry").get_package("codelldb"):get_install_path() .. "/codelldb"

      vim.fn.sign_define('DapBreakpoint', { text='' })

      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = codelldb,
          args = { "--port", "${port}" },
        }
      }

      dap.configurations.rust = {
        {
          name = "Attach to a running process",
          type = "codelldb",
          request = "attach",
          pid = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        }
      }
    end
  }, {
    'LiadOz/nvim-dap-repl-highlights',
    config = function()
      require('nvim-dap-repl-highlights').setup()
    end,
  }, {
    'rcarriga/cmp-dap',
    lazy = true,
    config = function()
      require("cmp").setup.filetype({ "dap-repl" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  }, {
    'nvim-telescope/telescope-dap.nvim',
    lazy = true,
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
}
