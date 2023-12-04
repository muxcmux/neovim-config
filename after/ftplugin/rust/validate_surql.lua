local get_root = function(bufn)
  local parser = vim.treesitter.get_parser(bufn, "rust", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local surreal_diagnostics = function(current_buf, ns)
  local query = vim.treesitter.query.parse(
    "rust",
    [[
      (raw_string_literal) @query
      (#match? @query "-- surql")
    ]]
  )

  local root = get_root(current_buf)

  vim.diagnostic.reset(ns, current_buf)

  local diagnostics = {}

  for _, node in query:iter_captures(root, current_buf, 0, -1) do
    local value = vim.treesitter.get_node_text(node, current_buf)

    local range = { node:range() }

    local tmp = os.tmpname()
    local file = io.open(tmp, "w+")

    if file then
      local lines = vim.split(value, "\n")

      for i = 2, #lines - 1 do
        file:write(lines[i] .. "\n")
      end

      file:close()

      local error_message = ""
      local error_line = 1
      local error_col = 0

      vim.fn.jobstart({ "surreal", "validate", tmp }, {
        stderr_buffered = true,
        on_stderr = function(_, data)
          if #data > 3 then
            error_message = table.concat(data, "\n")
            error_line = tonumber(vim.split(data[3], " | ")[1]) or 1
            local col = #(vim.split(data[4], " | ")[2] or "")
            local distance_to_first_char = vim.api.nvim_buf_get_lines(current_buf, range[1] + error_line, range[1] + error_line + 1, false)[1]:match("^%s*"):len()
            error_col = col + distance_to_first_char - 2
          end
        end,
        on_exit = function(_, exit_code)
          if exit_code > 0 then
            table.insert(diagnostics, {
              severity = vim.diagnostic.severity.ERROR,
              message = error_message,
              bufnr = current_buf,
              lnum = range[1] + error_line,
              col = error_col,
            })
            vim.diagnostic.set(ns, current_buf, diagnostics)
          end
          os.remove(tmp)
        end,
      })
    end
  end
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = vim.api.nvim_create_augroup("SurrealDiagnosticsEnter", { clear = true }),
  pattern = "*.rs",
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local ns = vim.api.nvim_create_namespace('SurrealDiagnostics')
    vim.api.nvim_buf_create_user_command(current_buf, "SurrealClearDiagnostics", function()
      vim.api.nvim_buf_clear_namespace(current_buf, ns, 0, -1)
      vim.diagnostic.reset(ns, current_buf)
    end, {})
    vim.api.nvim_buf_create_user_command(current_buf, "SurrealRunDiagnostics", function()
      surreal_diagnostics(current_buf, ns)
    end, {})
  end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("SurrealDiagnosticsWrite", { clear = true }),
  pattern = "*.rs",
  callback = function()
    vim.cmd("SurrealRunDiagnostics")
  end
})
