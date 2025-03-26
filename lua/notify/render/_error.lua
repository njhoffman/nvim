local api = vim.api
local base = require("notify.render.base")
local utils = require("notify.util.render")

vim.cmd([[
  highlight default link NotifyERRORCode Error
  highlight default link NotifyERRORMain healthWarning
  " highlight default link NotifyERRORFile Comment
  highlight default link NotifyERRORFile Normal
  highlight default link NotifyERRORLine Constant
  highlight default link NotifyERRORMessage Title
  highlight default link NotifyERRORStack Comment
  highlight default link NotifyERRORFileLinked markdownLinkText
]])

local file_pfx = string.gsub(vim.fn.stdpath("config") .. "/", os.getenv("HOME") .. "/", "")

local get_path = function(file)
  local path = vim.fn.trim(file) or file
  local file_match = string.match(path, ".*" .. file_pfx)
  if file_match then
    path = vim.fn.stdpath("config") .. "/" .. string.gsub(path, file_match, "")
  elseif not string.match(path, "^/") then
    path = vim.fn.stdpath("config") .. "/" .. string.gsub(path, "^./", "")
  end
  return path
end

local logger = require("logger").init("notifier")
local log_parts = function(parts, lines)
  local output = {
    "[title] " .. parts.title,
    "[code]  " .. parts.code,
    "[mess]  " .. parts.message,
    "[line]  " .. parts.line,
    "[file]  " .. parts.file,
    "[path]  " .. parts.path,
    "[short] " .. parts.shortfile,
  }
  for i, stackgroup in ipairs(parts.stackgroups) do
    table.insert(output, "[stack " .. i .. "]\n    " .. table.concat(stackgroup, "\n    "))
  end
  table.insert(output, '[lines]\n    "' .. table.concat(lines, '"\n    "') .. '"')
  if #parts.title == 0 or #parts.stack == 0 or (parts.line and type(parts.line) == "number") then
    logger:warn("Invalid error parsing \n  " .. table.concat(output, "\n  "))
  else
    logger:debug("Successful error parsing \n  " .. table.concat(output, "\n  "))
  end
end

local get_stackgroups = function(lines)
  local stackgroups = {}
  local stackline = 0
  for i, line in pairs(lines) do
    if line.match(line, "stack traceback:") then
      stackline = stackline == 0 and i or stackline
      table.insert(stackgroups, {})
    elseif stackline > 0 then
      line = utils.path_nvim(string.gsub(line, "^%s+", ""))
      if string.len(line) > 0 then
        table.insert(stackgroups[#stackgroups], line)
      end
    end
  end
  return stackgroups, stackline
end

local get_error_parts = function(lines)
  local stackgroups, stackline = get_stackgroups(lines)

  local title_line = vim.trim(lines[stackline > 0 and (stackline - 1) or 1])
  local parts = {
    code = string.match(title_line, ":?(E[%d]+)") or "",
    title = string.match(title_line, ":?E[%d]+: ([^:]+:[^:]+:[^:]+)")
      or string.match(title_line, ": ([^:]+:[^:]+:[^:]+)")
      or "",
    stackgroups = stackgroups,
  }

  parts.file = string.match(title_line, "([^: ]*):") or ""
  parts.line = string.match(title_line, "[^: ]*:([^:]*):") or ""
  parts.message = string.match(title_line, "[^: ]*:[^:]*: ([^:]*)") or ""
  parts.path = get_path(parts.file)
  parts.shortfile = utils.path_nvim(string.gsub(parts.path, "^%s+", ""))
  vim.dbglog(parts, lines)
  log_parts(parts, lines)
  return parts
end

local box_render = function(bufnr, notif, highlights, config)
  local left_icon = notif.icon .. " "
  local max_message_width = math.max(math.max(unpack(vim.tbl_map(function(line)
    return vim.fn.strchars(line)
  end, notif.message))))
  local right_title = notif.title[2]
  local left_title = notif.title[1]
  local title_accum = vim.str_utfindex(left_icon)
    + vim.str_utfindex(right_title)
    + vim.str_utfindex(left_title)

  local left_buffer = string.rep(" ", math.max(0, max_message_width - title_accum))

  local namespace = base.namespace()
  api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
  api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = {
      { " " },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = { { " " }, { right_title, highlights.title }, { " " } },
    virt_text_pos = "right_align",
    priority = 10,
  })
  api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
    virt_text = {
      {
        string.rep(
          "━",
          math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())
        ),
        highlights.border,
      },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
end

local minimal_render = function(bufnr, notif, highlights, config)
  local max_message_width = math.max(math.max(unpack(vim.tbl_map(function(line)
    return vim.fn.strchars(line)
  end, notif.message))))
  local title = notif.title[1] or ""
  local title_accum = vim.str_utfindex(title)

  local title_buffer = string.rep(
    " ",
    (math.max(max_message_width, title_accum, config.minimum_width()) - title_accum) / 2
  )

  local namespace = base.namespace()

  -- api.nvim_buf_set_lines(bufnr, 0, 1, false, { '', '' })

  -- api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
  --   virt_text = {
  --     {
  --       string.rep('━', math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())),
  --       highlights.border,
  --     },
  --   },
  --   virt_text_win_col = 0,
  --   priority = 10,
  -- })
  api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = {
      { title_buffer .. title .. title_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
end

-- stylua: ignore
local error_hl_map = {
  code        = 'NotifyERRORCode',
  title       = 'NotifyERRORMain',
  file        = 'NotifyERRORFile',
  file_linked = 'NotifyERRORFileLinked',
  line        = 'NotifyERRORLine',
  message     = 'NotifyERRORMessage',
  stack       = 'NotifyERRORStack',
}

local function error_highlighting(bufnr, notif, highlights, config, parts, line_start)
  local namespace = base.namespace()

  local lines = {}
  local hls = {}
  local col = 0
  if #parts.code > 0 then
    lines[1] = parts.code .. ":"
    table.insert(hls, { error_hl_map.code, 0, 0, #parts.code })
    col = #parts.code + 1
  end
  lines[1] = (lines[1] or "") .. parts.title
  table.insert(hls, { error_hl_map.title, 0, col, col + #parts.title })

  lines[2] = parts.shortfile .. ":" .. parts.line .. ":" .. parts.message
  local file_hl = notif.file_linked and error_hl_map.file_linked or error_hl_map.file
  table.insert(hls, { file_hl, 1, 0, #parts.shortfile })

  col = #parts.shortfile + 1
  table.insert(hls, { error_hl_map.line, 1, col, col + #parts.line })

  col = col + #parts.line + 1

  local n = 0
  for _, stack_group in ipairs(parts.stackgroups) do
    for i, stack in ipairs(stack_group) do
      n = n + 1
      lines[2 + n] = "  " .. stack
      table.insert(hls, { error_hl_map.stack, 1 + n, 0, #lines[2 + n] })
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, line_start, -1, true, lines)

  for _, hl in ipairs(hls) do
    local opt = { hl_group = hl[1], end_col = hl[4] }
    vim.api.nvim_buf_set_extmark(bufnr, namespace, hl[2] + line_start, hl[3], opt)
  end

  -- api.nvim_buf_set_lines(bufnr, 0, 1, false, { '', '' })
  -- api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
  --   virt_text = {
  --     { title_buffer .. title .. title_buffer, highlights.title },
  --   },
  --   virt_text_win_col = 0,
  --   priority = 10,
  -- })
end

return function(bufnr, notif, highlights, config)
  local msg = notif.message
  local parts = get_error_parts(msg)
  local line_start = 0
  local code = parts.code and (" " .. parts.code) or ""
  if parts.path and utils.file_exists(parts.path) then
    vim.api.nvim_buf_set_var(bufnr, "notify_file", parts.path)
    vim.api.nvim_buf_set_var(bufnr, "notify_line", parts.line)
    notif.file_linked = true
    minimal_render(bufnr, notif, highlights, config)
    -- box_render(bufnr, notif, highlights, config)
    -- line_start = 2
  end
  error_highlighting(bufnr, notif, highlights, config, parts, line_start)
end
