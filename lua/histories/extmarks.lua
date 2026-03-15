local ns = vim.api.nvim_create_namespace("histories_extmarks")

local hl_groups = { "ExtmarkRange1", "ExtmarkRange2", "ExtmarkRange3" }
local hl_colors = { "#300000", "#003060", "#004c36" }

for i, group in ipairs(hl_groups) do
  vim.api.nvim_set_hl(0, group, { bg = hl_colors[i] })
end

-- List of { id = extmark_id, bufnr = buffer_number }, most recent first
local marks = {}

local function clamp_col(bufnr, row, col)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  if not line then
    return 0
  end
  return math.min(col, #line)
end

local function update_highlight(entry, hl_group)
  local mark = vim.api.nvim_buf_get_extmark_by_id(entry.bufnr, ns, entry.id, { details = true })
  if not mark or #mark == 0 then
    return
  end
  local details = mark[3]
  vim.api.nvim_buf_set_extmark(entry.bufnr, ns, mark[1], mark[2], {
    id = entry.id,
    hl_group = hl_group,
    end_row = details.end_row,
    end_col = details.end_col,
  })
end

local function add_mark()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Exit visual mode so '< '> marks are set
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

  local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
  local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")

  local start_row = start_pos[1] - 1
  local start_col = start_pos[2]
  local end_row = end_pos[1] - 1
  local end_col = end_pos[2]

  -- Clamp end_col (handles v:maxcol from linewise selections)
  end_col = clamp_col(bufnr, end_row, end_col + 1)

  -- Remove oldest if we already have 3
  if #marks >= 3 then
    local oldest = table.remove(marks)
    pcall(vim.api.nvim_buf_del_extmark, oldest.bufnr, ns, oldest.id)
  end

  -- Create the new extmark
  local id = vim.api.nvim_buf_set_extmark(bufnr, ns, start_row, start_col, {
    hl_group = hl_groups[1],
    end_row = end_row,
    end_col = end_col,
  })

  table.insert(marks, 1, { id = id, bufnr = bufnr })

  -- Update highlight groups on shifted marks
  for i = 2, #marks do
    update_highlight(marks[i], hl_groups[i])
  end
end

local function ext_info()
  if #marks == 0 then
    print("No active extmarks")
    return
  end
  for i, entry in ipairs(marks) do
    local ok, mark = pcall(vim.api.nvim_buf_get_extmark_by_id, entry.bufnr, ns, entry.id, { details = true })
    if ok and mark and #mark > 0 then
      local details = mark[3]
      local buf_name = vim.api.nvim_buf_get_name(entry.bufnr)
      buf_name = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":~:.") or "[scratch]"
      print(
        string.format(
          "#%d  %s  %s  rows %d-%d  cols %d-%d",
          i,
          hl_groups[i],
          buf_name,
          mark[1] + 1,
          (details.end_row or mark[1]) + 1,
          mark[2],
          details.end_col or mark[2]
        )
      )
    else
      print(string.format("#%d  (invalid — extmark no longer exists)", i))
    end
  end
end

local function ext_clear()
  for _, entry in ipairs(marks) do
    pcall(vim.api.nvim_buf_del_extmark, entry.bufnr, ns, entry.id)
  end
  marks = {}
  print("Extmarks cleared")
end

vim.keymap.set("x", "<F5>", add_mark, { noremap = true, silent = true, desc = "Add extmark at visual selection" })
vim.api.nvim_create_user_command("ExtInfo", ext_info, { desc = "Print info about active extmarks" })
vim.api.nvim_create_user_command("ExtClear", ext_clear, { desc = "Clear all extmark highlights" })

return {
  add_mark = add_mark,
  ext_info = ext_info,
  ext_clear = ext_clear,
}
