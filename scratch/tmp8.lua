local get_widths = function(tbl)
  local widths = {}
  for _, row in ipairs(tbl) do
    for i, col in ipairs(row) do
      local w = vim.fn.strdisplaywidth(col)
      widths[i] = math.max(w, widths[i] or 0)
    end
  end
  local total = 0
  for _, width in ipairs(widths) do
    total = total + width
  end
  return widths, total
end

local parse_extmark = function(extmark, buf_id)
  -- hl_group = "IlluminatedWordText", hl_eol, priority
  -- sign_hl_group = 'SmoothCursor', sign_name = 'smoothcursor', sign_text = "> "
  -- virt_text = { [1] = { [1] = "│", [2] = "HLChunk1" } },
  -- virt_text = {
  --     [1] = { [1] = "│", [2] = { [1] = "@ibl.whitespace.char.1", [2] = "@ibl.indent.char.1" } },
  --     [2] = { [1] = " ", [2] = "@ibl.whitespace.char.1" } },
  --     hl_mode = "combine", priority = 100, virt_text_pos, virt_text_hide,
  --     virt_text_repeat_linebreak, virt_text_win_col
  -- virt_lines = {}

  local props = {
    buf_id = tostring(buf_id),
    ext_id = tostring(extmark[1]),
    pos = extmark[2] .. ":" .. extmark[3],
    end_pos = extmark[4].end_row and (extmark[4].end_row .. ":" .. extmark[4].end_col) or "",
    priority = tostring(extmark[4].priority),
    type = (
      extmark[4].virt_text and "text"
      or extmark[4].virt_lines and "lines"
      or extmark[4].hl_group and "hl"
      or extmark[4].sign_name and "sign"
      or ""
    ),
    primary = "",
    secondary = "",
  }
  if props.type == "hl" then
    props.primary = extmark[4].hl_group
    props.secondary = "hl_eol: " .. tostring(extmark[4].hl_eol)
  elseif props.type == "sign" then
    props.primary = extmark[4].sign_name
    props.secondary = '"' .. extmark[4].sign_text .. '" ' .. extmark[4].sign_hl_group
  elseif props.type == "text" then
    for _, virt_text in ipairs(extmark[4].virt_text) do
      props.primary = props.primary .. virt_text[1]
    end
    props.secondary = "pos: " .. extmark[4].virt_text_pos
  end

  return {
    props.buf_id,
    props.ext_id,
    props.pos,
    props.end_pos,
    props.type,
    props.primary,
    props.secondary,
    props.priority,
  }
end

local print_namespace = function(row, widths)
  local row_out = string.format(
    "%-"
      .. (widths[2] + 3 + widths[1])
      .. "s => %"
      .. widths[3] + 3
      .. "s "
      .. (row[4] ~= 0 and "  %" .. "s ext" or ""),
    row[2] .. " (" .. row[1] .. ")",
    row[3] ~= 0 and row[3] .. " hl" or "",
    row[4] ~= 0 and row[4] or ""
  )
  return row_out
end

local print_extmark = function(row, widths)
  -- 0     249   93:15
  -- 0  771615    5:0-6:9     hl          IlluminatedWordText   hl_eol:false      4096
  -- 0       2   98:70-98:71  hl          MatchParen            hl_eol:false      4096
  -- 0      32    0:0         sign        RecallSign            " " RecallMark   10
  -- 9  866056  126:0         virt_text   "| "                  pos: overlay
  --                          "|" (@ibl.whitespace.char.1, @ibl.indent.char.1)
  --                          " " (@ibl.whitespace.char.1)
  local row_out = string.format(
    "%-"
      .. widths[1]
      .. "s "
      .. " %"
      .. widths[2]
      .. "s "
      .. " %"
      .. widths[3]
      .. "s "
      .. " %"
      .. widths[4]
      .. "s "
      .. " %"
      .. widths[5]
      .. "s "
      .. (row[5] == "text" and " '%-" .. widths[6] .. "s' " or "  %-" .. widths[6] .. "s  ")
      .. " %"
      -- .. widths[7]
      .. "s "
      .. " %"
      -- .. widths[8]
      .. "s "
      .. " %"
      -- .. widths[8]
      .. "s ",
    row[1],
    row[2],
    row[3],
    row[4] ~= "0:0" and row[4] or "",
    row[5],
    row[6],
    row[7],
    row[8],
    widths[6]
  )
  return row_out
end

local list_namespaces = function(opts)
  local default_opts = {
    ns_id = nil,
    ns_name = nil,
    buf_id = nil,
    win_id = nil,
    sort = "name", -- hls, id, name, extmarks
    show_empty = false,
    show_extmarks = false,
    show_virt_details = false,
  }
  opts = vim.tbl_extend("force", default_opts, opts or {})

  local winid = opts.win_id or vim.api.nvim_get_current_win()
  local bufid = opts.buf_id or vim.fn.winbufnr(winid)
  local bufs = { bufid }
  if not opts.buf_id or opts.buf_id == -1 then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_is_valid(buf) then
        table.insert(bufs, buf)
      end
    end
  elseif opts.buf_id then
    bufs = { opts.buf_id }
  end

  local ns_table = {}
  local ns_extmarks = {}
  local ns_highlights = {}

  local namespaces = vim.api.nvim_get_namespaces()
  local ns_curr = vim.api.nvim_get_hl_ns({ winid = winid })
  namespaces["_buffer"] = ns_curr
  namespaces["_global"] = 0
  for name, ns in pairs(namespaces) do
    -- namespace id, namespace name, highlights, extmarks
    local row = { ns, name, 0, 0 }
    ns_highlights[name] = vim.api.nvim_get_hl(ns, {})
    row[3] = #vim.tbl_keys(ns_highlights[name])

    if ns ~= 0 then
      for _, buf in ipairs(bufs) do
        -- type = 'highlight', -- highlight, sign, virt_text, virt_lines
        local extmarks =
          vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, { details = true, hl_name = true })
        row[4] = row[4] + #extmarks
        if #extmarks > 0 then
          ns_extmarks[name] = ns_extmarks[name] or {}
          ns_extmarks[name][buf] = extmarks
        end
      end
    end
    table.insert(ns_table, row)
  end

  table.sort(ns_table, function(a, b)
    if opts.sort == "name" then
      return string.lower(a[2]) < string.lower(b[2])
    elseif opts.sort == "hls" then
      return a[3] < b[3]
    elseif opts.sort == "extmarks" then
      return a[4] < b[4]
    else
      return a[1] < b[1]
    end
  end)

  local widths, total_width = get_widths(ns_table)

  local output = {}
  table.insert(output, "\n  ** " .. #bufs .. " bufs: " .. table.concat(bufs, " ") .. " **")
  for _, row in ipairs(ns_table) do
    if opts.show_empty or (row[3] > 0 or row[4] > 0) then
      local ns_out = print_namespace(row, widths)
      if opts.show_extmarks and row[4] > 0 then
        local extmarks = {}
        local buf_extmarks = ns_extmarks[row[2]]
        for buf_id_ext, _ in pairs(buf_extmarks) do
          for _, extmark in ipairs(buf_extmarks[buf_id_ext]) do
            table.insert(extmarks, parse_extmark(extmark, buf_id_ext))
          end
        end
        local ext_widths, ext_total = get_widths(extmarks)
        local ext_out = ""
        for i, ext_row in ipairs(extmarks) do
          ext_out = ext_out .. "\n   " .. print_extmark(ext_row, ext_widths)
          --   -- local virt_text = {}
          --   -- if extmark[4].virt_text and opts.show_virt_details then
          --   --   table.insert(virt_text, parse_virt_text(extmark, buf_id_ext))
          --   -- end
          -- end
        end
        ns_out = #ext_out > 0 and ns_out .. ext_out or ns_out
      end
      table.insert(output, ns_out)
    end
  end
  table.insert(output, string.rep("-", total_width + 15))
  return output
end

local rows = list_namespaces({ buf = 0, show_extmarks = true })
vim.dbglog(table.concat(rows, "\n  "))
-- for _, row in ipairs(rows) do
--   vim.dbglog(row)
-- end
