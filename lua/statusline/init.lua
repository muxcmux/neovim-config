require('lsp-progress').setup({
  spin_update_time = 110,
  spinner = { "󱑖", "󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕" },
  format = function(client_messages)
    if #client_messages > 0 then
        return table.concat(client_messages, " ")
    end
    return ""
  end,
  client_format = function(client_name, spinner, series_messages)
    return #series_messages > 0
        and (spinner .. " " .. client_name .. ": " .. table.concat(
          series_messages,
          ", "
        ))
    or nil
  end,
})

vim.api.nvim_create_augroup("LspProgressUpdatedStatusLineGroup", { clear = true })
vim.api.nvim_create_autocmd("user", {
  group = "LspProgressUpdatedStatusLineGroup",
  pattern = "LspProgressStatusUpdated",
  callback = function()
    vim.schedule(function() vim.cmd("redrawstatus") end)
  end,
})

local M = {}

function M.statusline()
  local parts = {
    [[ %{luaeval("require'statusline'.buffer_name()")} ]],

    [[%m%r ]],

    [[%{%luaeval("require'nvim-navic'.get_location()")%} ]],

    [[%> %{luaeval("require'lsp-progress'.progress()")} ]],

    -- switch to the right side
    "%=",

    [[%{%luaeval("require'statusline'.diagnostic_status()")%} ]],

    [[%P ]],

    -- [[  %3{codeium#GetStatusString()} ]],

    -- %# starts a highlight group; Another # indicates the end of the highlight group name
    -- This causes the next content to display in colors (depending on the color scheme)
    "%#warningmsg#",

    -- vimL expressions can be placed into `%{ ... }` blocks
    -- The expression uses a conditional (ternary) operator: <condition> ? <truthy> : <falsy>
    -- If the current file format is not 'unix', display it surrounded by [], otherwise show nothing
    "%{&ff!='unix'?'  ['.&ff.'] ':''}",

    -- Resets the highlight group
    "%*",

    "%#warningmsg#",
    -- Same as before with the file format, except for the file encoding and checking for `utf-8`
    "%{(&fenc!='utf-8'&&&fenc!='')?'  ['.&fenc.'] ':''}",
    "%*",
  }

  return table.concat(parts, '')
end

function M.diagnostic_status()
  local status = {}
  local groups = {
    Error = vim.diagnostic.severity.ERROR,
    Warn = vim.diagnostic.severity.WARN,
    Hint = vim.diagnostic.severity.HINT,
    Info = vim.diagnostic.severity.INFO,
  }

  local bg = vim.api.nvim_get_hl(0, { name = 'StatusLine' }).bg

  for type, severity in pairs(groups) do
    local fg = vim.api.nvim_get_hl(0, { name = 'DiagnosticSign' .. type}).fg
    vim.api.nvim_set_hl(0, 'StatusLineDiagnostics' .. type, { fg = fg, bg = bg })

    local num = #vim.diagnostic.get(0, { severity = severity })

    if num > 0 then
      table.insert(status, ' %#StatusLineDiagnostics' .. type .. '#●%* ' .. num)
    end
  end

  if #status > 0 then
    return ' ' .. table.concat(status, ' ') .. '  '
  end

  return ''
end

function M.buffer_name()
  local uri = vim.uri_from_bufnr(vim.api.nvim_get_current_buf())
  -- [No name]
  if uri == 'file://' then
    return ''
  -- Oil filebrowser
  elseif vim.startswith(uri, 'oil://') then
    return string.format('󰝰 %s', uri:gsub('^oil://', ''))
  -- Git
  elseif vim.startswith(uri, 'fugitive://') then
    return string.format(' %s', uri:gsub('^fugitive://', ''):gsub('.git//', ''))
  -- any other file
  else
    local file = vim.fn.fnamemodify(vim.uri_to_fname(uri), ':.')
    local icon = require'nvim-web-devicons'.get_icon(file) or ''
    return string.format('%s %s', icon, file)
  end
end

return M
