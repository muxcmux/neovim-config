-- After extracting cargo's compiler metadata with the cargo inspector
-- parse it to find the binary to debug
local function parse_cargo_metadata(cargo_metadata)
  -- Iterate backwards through the metadata list since the binary
  -- we're interested will be near the end (usually second to last)
  for i = 1, #cargo_metadata do
    local json_table = cargo_metadata[#cargo_metadata + 1 - i]

    -- Some metadata lines may be blank, skip those
    if string.len(json_table) ~= 0 then
      -- Each matadata line is a JSON table,
      -- parse it into a data structure we can work with
      json_table = vim.fn.json_decode(json_table)

      -- Our binary will be the compiler artifact with an executable defined
      if json_table["reason"] == "compiler-artifact" and json_table["executable"] ~= vim.NIL then
        return json_table["executable"]
      end
    end
  end

  return nil
end

-- Parse the `cargo` section of a DAP configuration and add any needed
-- information to the final configuration to be handed back to the adapter.
-- E.g.: When debugging a test, cargo generates a random executable name.
-- We need to ask cargo for the name and add it to the `program` config field
-- so LLDB can find it.
local function cargo_inspector(config)
  local final_config = vim.deepcopy(config)

  -- Create a buffer to receive compiler progress messages
  local compiler_msg_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(compiler_msg_buf, "buftype", "nofile")

  -- Open a split to show those messages
  vim.cmd('split')
  vim.cmd('wincmd j')
  vim.cmd('resize 10')
  local compiler_msg_window = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(compiler_msg_window, compiler_msg_buf)

  -- Instruct cargo to emit compiler metadata as JSON
  local message_format = "--message-format=json"
  if final_config.cargo.args ~= nil then
    table.insert(final_config.cargo.args, message_format)
  else
    final_config.cargo.args = { message_format }
  end

  -- Build final `cargo` command to be executed
  local cargo_cmd = { "cargo", "build" }
  for _, value in pairs(final_config.cargo.args) do
    table.insert(cargo_cmd, value)
  end

  vim.api.nvim_buf_set_name(compiler_msg_buf, " " .. table.concat(cargo_cmd, ' '))

  -- Run `cargo`, retaining buffered `stdout` for later processing,
  -- and emitting compiler messages to to a window
  local compiler_metadata = {}
  local cargo_job = vim.fn.jobstart(cargo_cmd, {
    clear_env = false,
    env = final_config.cargo.env,
    cwd = final_config.cwd,

    -- Cargo emits compiler metadata to `stdout`
    stdout_buffered = true,
    on_stdout = function(_, data) compiler_metadata = data end,

    -- Cargo emits compiler messages to `stderr`
    on_stderr = function(_, data)
      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.fn.appendbufline(compiler_msg_buf, "$", data)
        vim.api.nvim_win_set_cursor(compiler_msg_window, { vim.api.nvim_buf_line_count(compiler_msg_buf), 1 })
        vim.cmd "redraw"
      end
    end,

    on_exit = function(_, exit_code)
      -- Cleanup the compile message window and buffer
      if vim.api.nvim_win_is_valid(compiler_msg_window) then
        vim.api.nvim_win_close(compiler_msg_window, { force = true })
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.api.nvim_buf_delete(compiler_msg_buf, { force = true })
      end

      -- If compiling succeeded, send the compile metadata off for processing
      -- and add the resulting executable name to the `program` field of the final config
      if exit_code == 0 then
        local executable_name = parse_cargo_metadata(compiler_metadata)
        if executable_name ~= nil then
          final_config.program = executable_name
        else
          vim.notify("Cargo could not find an executable for debug configuration", vim.log.levels.ERROR)
        end
      else
        vim.notify("Cargo failed to compile debug configuration", vim.log.levels.ERROR)
      end
    end,
  })

  -- Get the rust compiler's commit hash for the source map
  local rust_hash = ""
  local rust_hash_stdout = {}
  local rust_hash_job = vim.fn.jobstart({ "rustc", "--version", "--verbose" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data) rust_hash_stdout = data end,
    on_exit = function()
      for _, line in pairs(rust_hash_stdout) do
        local start, finish = string.find(line, "commit-hash: ", 1, true)

        if start ~= nil then rust_hash = string.sub(line, finish + 1) end
      end
    end,
  })

  -- Get the location of the rust toolchain's source code for the source map
  local rust_source_path = ""
  local rust_source_job = vim.fn.jobstart({ "rustc", "--print", "sysroot" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data) rust_source_path = data[1] end,
  })

  -- Wait until compiling and parsing are done
  -- This blocks the UI (except for the :redraw above) and I haven't figured
  -- out how to avoid it, yet
  -- Regardless, not much point in debugging if the binary isn't ready yet
  vim.fn.jobwait { cargo_job, rust_hash_job, rust_source_job }

  -- Enable visualization of built in Rust datatypes
  final_config.sourceLanguages = { "rust" }

  -- Build sourcemap to rust's source code so we can step into stdlib
  rust_hash = "/rustc/" .. rust_hash .. "/"
  rust_source_path = rust_source_path .. "/lib/rustlib/src/rust/"
  if final_config.sourceMap == nil then final_config["sourceMap"] = {} end
  final_config.sourceMap[rust_hash] = rust_source_path

  -- Cargo section is no longer needed
  final_config.cargo = nil

  return final_config
end

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
        },
        enrich_config = function(config, on_config)
          if config["cargo"] ~= nil then on_config(cargo_inspector(config)) end
        end,
      }

      dap.configurations.rust = {
        {
          name = "Attach to a running process",
          type = "codelldb",
          request = "attach",
          pid = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        }, {
          name = "Build and run program",
          type = "codelldb",
          request = "launch",
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          cargo = {},
          args = function()
            local parts = {}
            for str in string.gmatch(vim.fn.input('Program arguments: '), "%S+") do
              table.insert(parts, str)
            end
            return parts
          end,
        },
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
