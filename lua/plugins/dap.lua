return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapToggleRepl' },
    keys = {
      { "<leader>db", ":DapToggleBreakpoint<cr>", desc = "Toggle breakpoint", silent = true },
      { "<leader>dc", ":DapContinue<cr>", desc = "Debugger continue", silent = true },
      { "<leader>dr", ":DapToggleRepl<cr>:wincmd j<cr>i", desc = "Open debugger repl", silent = true },
      { "<leader>di", ":DapStepIn<cr>", desc = "Debugger step in", silent = true },
      { "<leader>dn", ":DapStepOver<cr>", desc = "Debugger step over (next line)", silent = true },
      { "<leader>do", ":DapStepOut<cr>", desc = "Debugger step out", silent = true },
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
    'theHamsta/nvim-dap-virtual-text',
    lazy = true,
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  }, {
    'LiadOz/nvim-dap-repl-highlights',
    lazy = true,
    config = function()
      require('nvim-dap-repl-highlights').setup()
    end,
  }, {
    'rcarriga/cmp-dap',
    lazy = true,
    config = function()
      require("cmp").setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
              or require("cmp_dap").is_dap_buffer()
        end
      })
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
