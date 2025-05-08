local default_opts = {
  -- filter = { has_hls = true, has_leaked = true },
  filter = {},
  sort = "id",
  bufid = nil,
  winid = nil,
}

local list_namespaces = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  opts.winid = opts.winid or vim.api.nvim_get_current_win()
  opts.bufid = opts.bufid or vim.fn.winbufnr(opts.winid)
  local ns_curr = vim.api.nvim_get_hl_ns({ winid = opts.winid })

  local ns_table = {}
  local ns_extmarks = {}
  local ns_highlights = {}

  local namespaces = vim.api.nvim_get_namespaces()
  namespaces["_buffer"] = ns_curr
  namespaces["_global"] = 0

  for name, ns_id in pairs(namespaces) do
    local row = { ns_id, name, 0, 0 }
    ns_highlights[ns_id] = vim.api.nvim_get_hl(ns_id, {})
    row[3] = row[3] + #vim.tbl_keys(ns_highlights[ns_id])
    ns_extmarks[ns_id] = {}
    if ns_id ~= 0 then
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {
          -- type = 'highlight', -- highlight, sign, virt_text, virt_lines
          details = true,
          hl_name = true,
        })
        ns_extmarks[ns_id][buf] = extmarks
        row[4] = row[4] + #extmarks
        -- extmarks[1][4] = { end_col = 68, end_right_gravity = false, end_row = 4, hl_eol = false, hl_group = "MatchParen", ns_id = 15, priority = 4096, right_gravity = true }
        -- extmarks[1][4].virtual_text = { [1] = { [1] = "", [2] = "ActionHintsDefinition" }, [2] = { [1] = "", [2] = "ActionHintsReferences" }, [3] = { [1] = " 9", [2] = "ActionHintsCodeActions" } }, virt_text_hide = false, virt_text_pos = "eol"virt_text = { [1] = { [1] = " ", [2] = "ScrollbarHandle" } }, virt_text_hide = false, virt_text_pos = "right_align" }
      end
    end

    if vim.tbl_isempty(opts.filter) then
      table.insert(ns_table, row)
    else
      if opts.filter.has_hls and row[3] ~= 0 then
        table.insert(ns_table, row)
      elseif opts.filter.has_leaked and row[4] ~= 0 then
        table.insert(ns_table, row)
      end
    end
  end

  local widths = {}
  for _, row in ipairs(ns_table) do
    for i, col in ipairs(row) do
      local w = vim.fn.strdisplaywidth(col)
      widths[i] = math.max(w, widths[i] or 0)
    end
  end
  total_width = widths[1] + widths[2] + widths[3] + widths[4] + 7

  table.sort(ns_table, function(a, b)
    if opts.sort == "id" then
      return a[1] < b[1]
    elseif opts.sort == "name" then
      return a[2] < b[2]
    elseif opts.sort == "hls" then
      return a[3] < b[3]
    elseif opts.sort == "leaked" then
      return a[4] < b[4]
    end
  end)

  for _, row in ipairs(ns_table) do
    vim.dbglog(
      string.format(
        "%-"
          .. (widths[2] + 3 + widths[1])
          .. "s => %"
          .. widths[3]
          .. "s "
          .. (row[4] ~= 0 and "[%" .. "s leaks]" or ""),
        row[2] .. " (" .. row[1] .. ")",
        row[3],
        row[4] ~= 0 and row[4]
      )
    )
  end
  vim.dbglog(string.rep("-", total_width, ""))
end

local dump_namespaces = function()
  local nsn = vim.api.nvim_get_namespaces()
  local count = 0
  for name, ns_id in pairs(nsn) do
    local ns_count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, { details = true })
      -- if #extmarks > 0 then
      --   vim.dbglog(buf, name, #extmarks)
      -- end
      ns_count = ns_count + #extmarks
      count = count + #extmarks
    end
    if ns_count > 0 then
      vim.dbglog(string.format("%4s %s", ns_count, name))
    end
  end
  vim.dbglog(count)
end
-- dump_namespaces()
list_namespaces()
