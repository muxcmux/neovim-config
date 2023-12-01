local function log(data)
  local bufnr = 4
  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
end

local get_cmt_bds = function(block, opts)
  local user = vim.env.CMT_API_STAGING_KEY
  local pass = vim.env.CMT_API_STAGING_SECRET

  local url = string.format(
    "https://%s:%s@cmt-staging.builder.ai/api/v2/blocks?platform=ruby&name=%s",
    user, pass, block
  )

  vim.fn.jobstart({ "curl", url, "-H", "Content-Type: application/json", "-H", "Accept: application/json" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local success, json = pcall(vim.json.decode, data[1])

      if success and json.block and json.block.bds then
        opts.on_success(json.block.bds)
      elseif success and json.block and not json.block.bds then
        opts.on_failure("Missing bds record from CMT")
      elseif success and json.message then
        opts.on_failure(json.message)
      elseif success and json.error then
        opts.on_failure(json.error)
      else
        opts.on_failure("CMT made a boo-boo")
      end
    end,
    on_exit = opts.on_complete
  })
end

local block_name_for_cmt = function(gem_name)
  local possible_block_name = vim.split(gem_name, '-')[1]
  local parts = vim.fn.split(possible_block_name, '_')
  return table.concat(parts, '-')
end

local get_root = function(bufn)
  local parser = vim.treesitter.get_parser(bufn, "ruby", {})
  local tree = parser:parse()[1]
  return tree:root()
end

local update_diagnostics = function(ns, current_buf, diag)
  local diagnostics = {}
  for _, data in pairs(diag) do
    table.insert(diagnostics, data)
  end
  vim.diagnostic.set(ns, current_buf, diagnostics)
end

local set_diagnostics = function(current_buf, ns, gems)
  -- log(vim.split(vim.inspect(gems), "\n"))

  vim.api.nvim_buf_clear_namespace(current_buf, ns, 0, -1)
  vim.diagnostic.reset(ns, current_buf)

  local diag = {}

  for gem, data in pairs(gems) do
    local extmark = vim.api.nvim_buf_set_extmark(current_buf, ns, data.diagnostics.lnum, 0, { virt_text = { { "" } } })

    get_cmt_bds(data.cmt_name, {
      on_success = function(bds)
        local ver = data.version and data.version.value
        local req = data.require and data.require.value
        -- missing version
        if bds.version and not ver then
          table.insert(diag, vim.tbl_extend('force', data.diagnostics, {
            severity = vim.diagnostic.severity.WARN,
            message = string.format("Missing CMT version (%s)", bds.version),
          }))
        end
        -- version mismatch
        if ver and bds.version ~= ver then
          table.insert(diag, vim.tbl_extend('force', data.version.diagnostics, {
            severity = vim.diagnostic.severity.WARN,
            message = string.format("CMT version is different (%s)", bds.version),
          }))
        end
        -- missing require
        if bds.require and not req then
          table.insert(diag, vim.tbl_extend('force', data.diagnostics, {
            severity = vim.diagnostic.severity.WARN,
            message = string.format("Missing `require` (%s)", bds.require),
          }))
        end
        -- require missmatch
        if bds.require and req and bds.require ~= req then
          table.insert(diag, vim.tbl_extend('force', data.require.diagnostics, {
            severity = vim.diagnostic.severity.WARN,
            message = string.format("`require` in CMT is different (%s)", bds.require),
          }))
        end
        if not bds.require and req then
          table.insert(diag, vim.tbl_extend('force', data.require.diagnostics, {
            severity = vim.diagnostic.severity.WARN,
            message = "CMT does not specify `require`",
          }))
        end
      end,

      on_failure = function(message)
        table.insert(diag, vim.tbl_extend('force', data.diagnostics, {
          severity = vim.diagnostic.severity.ERROR,
          message = string.format("Checking %s in CMT failed: %s", gem, message),
        }))
      end,

      on_complete = function()
        vim.api.nvim_buf_del_extmark(current_buf, ns, extmark)
        update_diagnostics(ns, current_buf, diag)
      end,
    })
  end
end

local cmt_diagnostics = function(current_buf, ns)
  if vim.bo[current_buf].filetype ~= "ruby" then
    vim.notify("You must be in a ruby file", vim.log.levels.ERROR)
    return
  end

  local query = vim.treesitter.query.parse(
    "ruby",
    [[
  (call
    method: (identifier) @method (#eq? @method "source")
    arguments: (argument_list
      (string
        (string_content) @source (#eq? @source "https://gem.fury.io/engineerai")
      )
    )
    block: (do_block
      body: (body_statement
        (call
          method: (identifier) @gem (#eq? @gem "gem")
          arguments: (argument_list
            . (string
              (string_content) @block)
            (string
              (string_content) @version)?
            (pair
              key: [
                (hash_key_symbol) @hash_key (#eq? @hash_key "require")
                (simple_symbol) @hash_key (#eq? @hash_key "require")
              ]
              value: (string (string_content) @require)
            )?
          )
        )
      )
    )
  )
    ]]
  )

  local root = get_root(current_buf)

  local last_block = ""

  local gems = {}

  for id, node in query:iter_captures(root, current_buf, 0, -1) do
    local name = query.captures[id]
    local value = vim.treesitter.get_node_text(node, current_buf)

    if vim.tbl_contains({ "block", "version", "require" }, name) then
      local start_row, start_col, end_row, end_col = node:range()

      -- log({ name .. " - " .. value})

      if name == "block" then
        gems[value] = {
          cmt_name = block_name_for_cmt(value),
          diagnostics = {
            bufnr = current_buf,
            lnum = start_row,
            col = start_col,
          },
        }
        last_block = value
      else
        gems[last_block][name] = {
          value = value,
          diagnostics = {
            bufnr = current_buf,
            lnum = start_row,
            end_lnum = end_row,
            col = start_col,
            end_col = end_col,
          },
        }
      end
    end
  end

  set_diagnostics(current_buf, ns, gems)
end


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = vim.api.nvim_create_augroup("CmtDiagnosticsEnter", { clear = true }),
  pattern = "Gemfile",
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local ns = vim.api.nvim_create_namespace('CmtDiagnostics')
    vim.api.nvim_buf_create_user_command(current_buf, "CmtClearDiagnostics", function()
      vim.api.nvim_buf_clear_namespace(current_buf, ns, 0, -1)
      vim.diagnostic.reset(ns, current_buf)
    end, {})
    vim.api.nvim_buf_create_user_command(current_buf, "CmtRunDiagnostics", function()
      cmt_diagnostics(current_buf, ns)
    end, {})
  end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("CmtDiagnosticsWrite", { clear = true }),
  pattern = "Gemfile",
  callback = function()
    vim.cmd("CmtRunDiagnostics")
  end
})

-- this puts the current line in the buffer on the right
-- local lnum = vim.fn.line(".")
-- vim.print(lnum)
-- log(vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false))
