-- local ns_id = 0
local ns_id = vim.api.nvim_create_namespace('nvim-notify')

local build_line = function(bufnr, linenum, parts)
  local baleia = require('baleia')
  local line = ''
  local hls = {}

  for _, part in pairs(parts) do
    local col_start = string.len(line)
    line = line .. part[1]
    local col_end = string.len(line)
    if part[2] then
      table.insert(hls, { part[2], col_start, col_end })
    end
  end
  -- vim.api.nvim_buf_set_lines(bufnr, linenum, -1, false, { line })
  baleia.buf_set_lines(bufnr, linenum, -1, false, { line })
  for _, hl in pairs(hls) do
    require("utils.hl").add_highlight(bufnr, ns_id, hl[1], linenum, hl[2], hl[3])
  end
end

local path_home = function(file)
  local home = os.getenv('HOME') or ''
  if string.len(home) > 0 then
    return string.gsub(file, home, '~')
  end
  return file
end

local path_nvim = function(file)
  local nvim = vim.fn.stdpath('config') .. '/'
  if string.len(nvim) > 0 then
    return string.gsub(file, nvim, '')
  end
  return file
end

local lines_width = function(lines)
  local ansi_pattern = '\x1b[[0-9][:;0-9]*m'

  return math.max(math.max(unpack(vim.tbl_map(function(line)
    line = line:gsub(ansi_pattern, '')
    return vim.fn.strchars(string.gsub(line, '^%s+', ''))
  end, lines))))
end

local render_box = function(bufnr, highlights, title, width)
  local minimum_width = 20
  local left_icon = ' '
  local right_title = title[2]
  local left_title = title[1]
  local title_accum = vim.str_utfindex(left_icon, "utf-32") + vim.str_utfindex(right_title, "utf-32") + vim.str_utfindex(left_title, "utf-32")

  local left_buffer = string.rep(' ', math.max(0, width - title_accum))
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { '', '' })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = {
      { ' ' },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = { { ' ' }, { right_title, highlights.title }, { ' ' } },
    virt_text_pos = 'right_align',
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 1, 0, {
    virt_text = {
      {
        string.rep('━', math.max(vim.str_utfindex(left_buffer, "utf-32") + title_accum + 2, minimum_width)),
        highlights.border,
      },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
end

return {
  build_line = build_line,
  path_home = path_home,
  path_nvim = path_nvim,
  lines_width = lines_width,
  render_box = render_box,
}
