local base = require("notify.render.base")

local lines_width = function(lines)
  local ansi_pattern = "\x1b[[0-9][:;0-9]*m"

  return math.max(math.max(unpack(vim.tbl_map(function(line)
    line = line:gsub(ansi_pattern, "")
    return vim.fn.strchars(string.gsub(line, "^%s+", ""))
  end, lines))))
end

local render_box = function(bufnr, highlights, title, width)
  local minimum_width = 20
  local left_icon = " "
  local right_title = title[2]
  local left_title = title[1]

  local title_accum = vim.str_utfindex(left_icon)
    + vim.str_utfindex(right_title)
    + vim.str_utfindex(left_title)
  local ns_id = base.namespace()

  local left_buffer = string.rep(" ", math.max(0, width - title_accum))
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = {
      { " " },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = { { " " }, { right_title, highlights.title }, { " " } },
    virt_text_pos = "right_align",
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 1, 0, {
    virt_text = {
      {
        string.rep("━", math.max(vim.str_utfindex(left_buffer) + title_accum + 2, minimum_width)),
        highlights.border,
      },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
end

local path_nvim = function(file)
  local nvim = vim.fn.stdpath("config") .. "/"
  if string.len(nvim) > 0 then
    return string.gsub(file, nvim, "")
  end
  return file
end

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return {
  path_nvim = path_nvim,
  file_exists = file_exists,
  render_box = render_box,
  lines_width = lines_width,
}
