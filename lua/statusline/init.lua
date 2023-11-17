local M = {}

function M.statusline()
  local parts = {
    [[%{luaeval("require'statusline'.diagnostic_status()")} ]],

    [[%<%{luaeval("require'statusline'.file_or_lsp_status()")} ]],

    [[%<%{luaeval("require'statusline'.dap_status()")} ]],

    -- switch to the right side
    "%=",

    [[%m%r ]],

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

local api = vim.api

function M.file_or_lsp_status()
  -- Neovim keeps the messages sent from the language server in a buffer and
  -- get_progress_messages polls the messages
  local messages = vim.lsp.util.get_progress_messages()
  local mode = api.nvim_get_mode().mode

  -- If neovim isn't in normal mode, or if there are no messages from the
  -- language server display the file name
  if mode ~= 'n' or vim.tbl_isempty(messages) then
    return M.buffer_name(vim.uri_from_bufnr(api.nvim_get_current_buf()))
  end

  local percentage
  local result = {}
  -- Messages can have a `title`, `message` and `percentage` property
  -- The logic here renders all messages into a stringle string
  for _, msg in pairs(messages) do
    if msg.message then
      table.insert(result, msg.title .. ': ' .. msg.message)
    else
      table.insert(result, msg.title)
    end
    if msg.percentage then
      percentage = math.max(percentage or 0, msg.percentage)
    end
  end
  if percentage then
    return string.format('%03d: %s', percentage, table.concat(result, ', '))
  else
    return table.concat(result, ', ')
  end
end

function M.diagnostic_status()
  local status = {}
  -- count the number of diagnostics with severity warning
  local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  -- If there are any errors only show the error count, don't include the number of warnings
  if num_errors > 0 then
    table.insert(status, ' 💀 ' .. num_errors)
  end
  -- Otherwise show amount of warnings, or nothing if there aren't any.
  local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  if num_warnings > 0 then
    table.insert(status, ' 💩 ' .. num_warnings)
  end
  if #status > 0 then
    return ' ' .. table.concat(status, ' ') .. '  '
  end
  return ''
end

function M.dap_status()
  if vim.fn.exists(':DapStepIn') > 0 then
    local status = require'dap'.status()
    if #status > 0 then
      return '  ' .. string.format(' %s', status)
    end

    return ''
  end

  return ''
end

function M.buffer_name(uri)
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
    local icon = require'nvim-web-devicons'.get_icon(uri) or ''
    return string.format('%s %s', icon, file)
  end
end

return M
