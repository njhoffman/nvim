local list_namespaces = function(opts)
  opts = opts or {}
  local filter = vim.fn.has_key(opts, "filter") and opts.filter
    or { has_hls = true, has_leaked = false }
  local sort = opts.sort or "id"
  local winid = opts.winid or vim.api.nvim_get_current_win()
  local bufid = opts.bufid or vim.fn.winbufnr(winid)
  local namespaces = vim.api.nvim_get_namespaces()
  local ns_curr = vim.api.nvim_get_hl_ns({ winid = winid })

  local ns_table = {}
  local ns_extmarks = {}
  local ns_highlights = {}
  namespaces["_buffer"] = ns_curr
  namespaces["_global"] = 0
  for name, ns in pairs(namespaces) do
    local row = { ns, name, 0, 0 }
    ns_highlights[ns] = vim.api.nvim_get_hl(ns, {})
    row[3] = row[3] + #vim.tbl_keys(ns_highlights[ns])
    ns_extmarks[ns] = {}
    if ns ~= 0 then
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {
          -- type = 'highlight', -- highlight, sign, virt_text, virt_lines
          details = true,
          hl_name = true,
        })
        ns_extmarks[ns][buf] = extmarks
        row[4] = row[4] + #extmarks
        -- extmarks[1][4] = { end_col = 68, end_right_gravity = false, end_row = 4, hl_eol = false, hl_group = "MatchParen", ns_id = 15, priority = 4096, right_gravity = true }
        -- extmarks[1][4].virtual_text = { [1] = { [1] = "", [2] = "ActionHintsDefinition" }, [2] = { [1] = "", [2] = "ActionHintsReferences" }, [3] = { [1] = " 9", [2] = "ActionHintsCodeActions" } }, virt_text_hide = false, virt_text_pos = "eol"virt_text = { [1] = { [1] = " ", [2] = "ScrollbarHandle" } }, virt_text_hide = false, virt_text_pos = "right_align" }
      end
    end
    if vim.tbl_isempty(filter) then
      table.insert(ns_table, row)
    else
      if filter.has_hls and row[3] ~= 0 then
        table.insert(ns_table, row)
      elseif filter.has_leaked and row[4] ~= 0 then
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
    if sort == "id" then
      return a[1] < b[1]
    elseif sort == "name" then
      return a[2] < b[2]
    elseif sort == "hls" then
      return a[3] < b[3]
    elseif sort == "leaked" then
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

return { list_namespaces = list_namespaces }
