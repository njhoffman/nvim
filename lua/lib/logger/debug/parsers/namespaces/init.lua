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
    "+" .. row[8],
    widths[6]
  )
  return row_out
end

local namespaces = function(opts)
  local default_opts = {
    ns = nil,
    buf = nil,
    win = nil,
    sort = "name", -- hls, id, name, extmarks
    show_empty = false,
    show_extmarks = false,
    show_virt_details = false,
  }
  opts = vim.tbl_extend("force", default_opts, opts or {})

  local bufs = {}
  if not opts.buf or opts.buf == -1 then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_is_valid(buf) then
        table.insert(bufs, buf)
      end
    end
  else
    table.insert(bufs, opts.buf or vim.fn.winbufnr(opts.win or 0))
  end

  local ns_table = {}
  local ns_extmarks = {}
  local ns_highlights = {}

  local namespaces = vim.api.nvim_get_namespaces()
  -- local ns_curr = vim.api.nvim_get_hl_ns({ winid = winid })
  -- namespaces["_buffer"] = ns_curr
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

--------------
---Extmarks Totals
--   global ns                     32,500   2,500      300
--   anon  ns (17)
--   named ns (32)                32,500   2,500      300
--   total
--
--------------
---Extmarks by namespace
--                       id   bufs   virt    sign    high    total
--   NeoComposerYank      3
--   MiniAnimateCursor    1
--   nvim-navbuddy        0
--   selecta_highlights
--   todo-comments
--   tiny-glimmer
--   git-conflict
--   vimade
--------------
-- Extmarks by buffer
--                    attrs    lines   virt    sign    high    total
--   buf_a_32
--   buf_i_22
--   buf_h_2
--   active (13)
--   hidden (18)
--   loaded
--   listed
--   total (17)
----------------

------------
-- vim.dbglog(table.concat(namespaces(), "\n"))

-- ** 1 bufs: 0 **
-- _global (0)                                   => 3890 hl
-- action_hints_references (47)                  =>           1 ext
--  0  1  260:0    text  ' 17 '  pos: eol  +4096  5
-- gitsigns_signs_ (58)                          =>           10 ext
--  0  124  123:0            +5  0
--  0  133  132:0            +5  0
--  0  134  133:0            +5  0
--  0  141  140:0            +5  0
--  0  142  141:0            +5  0
--  0  143  142:0            +5  0
--  0  149  148:0            +5  0
--  0  150  149:0            +5  0
--  0  158  157:0            +5  0
--  0  159  158:0            +5  0
-- indent_blankline (49)                         =>           212 ext
--  0  2188    1:0    text  '│         '  pos: overlay  +1  12
--  0  2189    2:0    text  '│         '  pos: overlay  +1  12
--  0  2190    3:0    text  '│ │     '  pos: overlay  +1  12
--  0  2191    4:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2192    5:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2193    6:0    text  '│ │     '  pos: overlay  +1  12
--  0  2194    7:0    text  '│         '  pos: overlay  +1  12
--  0  2195    8:0    text  '│         '  pos: overlay  +1  12
--  0  2196    9:0    text  '│         '  pos: overlay  +1  12
--  0  2197   10:0    text  '│ │     '  pos: overlay  +1  12
--  0  2198   11:0    text  '│         '  pos: overlay  +1  12
--  0  2199   12:0    text  '│         '  pos: overlay  +1  12
--  0  2200   16:0    text  '│         '  pos: overlay  +1  12
--  0  2201   17:0    text  '│         '  pos: overlay  +1  12
--  0  2202   18:0    text  '│         '  pos: overlay  +1  12
--  0  2203   19:0    text  '│         '  pos: overlay  +1  12
--  0  2204   20:0    text  '│         '  pos: overlay  +1  12
--  0  2205   21:0    text  '│         '  pos: overlay  +1  12
--  0  2206   22:0    text  '│         '  pos: overlay  +1  12
--  0  2207   23:0    text  '│         '  pos: overlay  +1  12
--  0  2208   24:0    text  '│         '  pos: overlay  +1  12
--  0  2209   25:0    text  '│         '  pos: overlay  +1  12
--  0  2210   26:0    text  '│         '  pos: overlay  +1  12
--  0  2211   27:0    text  '│ │     '  pos: overlay  +1  12
--  0  2212   28:0    text  '│ │     '  pos: overlay  +1  12
--  0  2213   29:0    text  '│ │     '  pos: overlay  +1  12
--  0  2214   30:0    text  '│ │     '  pos: overlay  +1  12
--  0  2215   31:0    text  '│ │     '  pos: overlay  +1  12
--  0  2216   32:0    text  '│ │     '  pos: overlay  +1  12
--  0  2217   33:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2218   34:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2219   35:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2220   36:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2221   37:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2297   38:0    text  '            '  pos: overlay  +1  12
--  0  2298   39:0    text  '│ │     '  pos: overlay  +1  12
--  0  2299   40:0    text  '│ │     '  pos: overlay  +1  12
--  0  2300   41:0    text  '│         '  pos: overlay  +1  12
--  0  2301   42:0    text  '│         '  pos: overlay  +1  12
--  0  2302   43:0    text  '│ │     '  pos: overlay  +1  12
--  0  2303   44:0    text  '│ │     '  pos: overlay  +1  12
--  0  2304   45:0    text  '│         '  pos: overlay  +1  12
--  0  2305   46:0    text  '│ │     '  pos: overlay  +1  12
--  0  2306   47:0    text  '│ │     '  pos: overlay  +1  12
--  0  2307   48:0    text  '│         '  pos: overlay  +1  12
--  0  2308   49:0    text  '│ │     '  pos: overlay  +1  12
--  0  2309   50:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2310   51:0    text  '│ │     '  pos: overlay  +1  12
--  0  2311   52:0    text  '│ │     '  pos: overlay  +1  12
--  0  2312   53:0    text  '│         '  pos: overlay  +1  12
--  0  2313   54:0    text  '│         '  pos: overlay  +1  12
--  0  2314   55:0    text  '│         '  pos: overlay  +1  12
--  0  2315   56:0    text  '│ │     '  pos: overlay  +1  12
--  0  2316   57:0    text  '│ │     '  pos: overlay  +1  12
--  0  2317   58:0    text  '│ │     '  pos: overlay  +1  12
--  0  2318   59:0    text  '│ │     '  pos: overlay  +1  12
--  0  2319   60:0    text  '│ │     '  pos: overlay  +1  12
--  0  2320   61:0    text  '│ │     '  pos: overlay  +1  12
--  0  2321   62:0    text  '│ │     '  pos: overlay  +1  12
--  0  2322   63:0    text  '│ │     '  pos: overlay  +1  12
--  0  2323   64:0    text  '│         '  pos: overlay  +1  12
--  0  2324   68:0    text  '│         '  pos: overlay  +1  12
--  0  2325   69:0    text  '│ │     '  pos: overlay  +1  12
--  0  2326   70:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2327   71:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2328   72:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2329   73:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2330   74:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2331   75:0    text  '│ │     '  pos: overlay  +1  12
--  0  2332   76:0    text  '│ │     '  pos: overlay  +1  12
--  0  2333   77:0    text  '│ │     '  pos: overlay  +1  12
--  0  2334   78:0    text  '│         '  pos: overlay  +1  12
--  0  2335   79:0    text  '│         '  pos: overlay  +1  12
--  0  2336   83:0    text  '│         '  pos: overlay  +1  12
--  0  2337   84:0    text  '│         '  pos: overlay  +1  12
--  0  2338   85:0    text  '│         '  pos: overlay  +1  12
--  0  2339   86:0    text  '│         '  pos: overlay  +1  12
--  0  2340   87:0    text  '│         '  pos: overlay  +1  12
--  0  2341   88:0    text  '│         '  pos: overlay  +1  12
--  0  2342   89:0    text  '│         '  pos: overlay  +1  12
--  0  2437   90:0    text  '            '  pos: overlay  +1  12
--  0  2438   91:0    text  '│ │     '  pos: overlay  +1  12
--  0  2439   92:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2440   93:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2441   94:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2442   95:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2443   96:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2444   97:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2445   98:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2446   99:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2447  100:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2569  101:0    text  '            '  pos: overlay  +1  12
--  0  2690  102:0    text  '            '  pos: overlay  +1  12
--  0  2691  103:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2692  104:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2693  105:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2694  106:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2695  107:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2696  108:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2697  109:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2698  110:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2810  111:0    text  '            '  pos: overlay  +1  12
--  0  2811  112:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2812  113:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2813  114:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2814  115:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  2815  116:0    text  '│ │     '  pos: overlay  +1  12
--  0  2816  117:0    text  '│ │     '  pos: overlay  +1  12
--  0  2817  118:0    text  '│ │     '  pos: overlay  +1  12
--  0  2818  119:0    text  '│ │     '  pos: overlay  +1  12
--  0  2819  120:0    text  '│ │     '  pos: overlay  +1  12
--  0  2820  121:0    text  '│ │     '  pos: overlay  +1  12
--  0  2821  122:0    text  '│ │     '  pos: overlay  +1  12
--  0  2822  123:0    text  '│ │     '  pos: overlay  +1  12
--  0  2823  124:0    text  '│ │     '  pos: overlay  +1  12
--  0  2824  125:0    text  '│         '  pos: overlay  +1  12
--  0  2825  126:0    text  '│         '  pos: overlay  +1  12
--  0  2826  130:0    text  '│         '  pos: overlay  +1  12
--  0  2827  131:0    text  '│ │     '  pos: overlay  +1  12
--  0  2828  132:0    text  '│ │     '  pos: overlay  +1  12
--  0  2829  133:0    text  '│ │     '  pos: overlay  +1  12
--  0  2830  134:0    text  '│ │     '  pos: overlay  +1  12
--  0  2831  135:0    text  '│ │     '  pos: overlay  +1  12
--  0  2832  136:0    text  '│ │     '  pos: overlay  +1  12
--  0  2833  137:0    text  '│ │     '  pos: overlay  +1  12
--  0  2834  138:0    text  '│         '  pos: overlay  +1  12
--  0  2835  139:0    text  '│         '  pos: overlay  +1  12
--  0  2836  140:0    text  '│         '  pos: overlay  +1  12
--  0  2837  141:0    text  '│         '  pos: overlay  +1  12
--  0  3004  142:0    text  '            '  pos: overlay  +1  12
--  0  3005  143:0    text  '│ │     '  pos: overlay  +1  12
--  0  3006  144:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3007  145:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3008  146:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3009  147:0    text  '│ │     '  pos: overlay  +1  12
--  0  3010  148:0    text  '│         '  pos: overlay  +1  12
--  0  3011  149:0    text  '│ │     '  pos: overlay  +1  12
--  0  3012  150:0    text  '│         '  pos: overlay  +1  12
--  0  3013  151:0    text  '│         '  pos: overlay  +1  12
--  0  3014  152:0    text  '│         '  pos: overlay  +1  12
--  0  3015  153:0    text  '│         '  pos: overlay  +1  12
--  0  3016  154:0    text  '│         '  pos: overlay  +1  12
--  0  3017  155:0    text  '│         '  pos: overlay  +1  12
--  0  3018  156:0    text  '│         '  pos: overlay  +1  12
--  0  3019  157:0    text  '│         '  pos: overlay  +1  12
--  0  3020  158:0    text  '│         '  pos: overlay  +1  12
--  0  3021  159:0    text  '│         '  pos: overlay  +1  12
--  0  3022  160:0    text  '│         '  pos: overlay  +1  12
--  0  3023  161:0    text  '│ │     '  pos: overlay  +1  12
--  0  3024  162:0    text  '│ │     '  pos: overlay  +1  12
--  0  3025  163:0    text  '│ │     '  pos: overlay  +1  12
--  0  3026  164:0    text  '│ │     '  pos: overlay  +1  12
--  0  3027  165:0    text  '│ │     '  pos: overlay  +1  12
--  0  3028  166:0    text  '│ │     '  pos: overlay  +1  12
--  0  3029  167:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3030  168:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3031  169:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3032  170:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3033  171:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3034  172:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3035  173:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3036  174:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3037  175:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3038  176:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3039  177:0    text  '│ │     '  pos: overlay  +1  12
--  0  3040  178:0    text  '│ │     '  pos: overlay  +1  12
--  0  3041  179:0    text  '│         '  pos: overlay  +1  12
--  0  3042  180:0    text  '│         '  pos: overlay  +1  12
--  0  3043  181:0    text  '│         '  pos: overlay  +1  12
--  0  3044  182:0    text  '│ │     '  pos: overlay  +1  12
--  0  3045  183:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3046  184:0    text  '│ │     '  pos: overlay  +1  12
--  0  3047  185:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3048  186:0    text  '│ │     '  pos: overlay  +1  12
--  0  3049  187:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3050  188:0    text  '│ │     '  pos: overlay  +1  12
--  0  3051  189:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3052  190:0    text  '│ │     '  pos: overlay  +1  12
--  0  3053  191:0    text  '│         '  pos: overlay  +1  12
--  0  3054  192:0    text  '│         '  pos: overlay  +1  12
--  0  3055  193:0    text  '│         '  pos: overlay  +1  12
--  0  3056  194:0    text  '│         '  pos: overlay  +1  12
--  0  3057  195:0    text  '│         '  pos: overlay  +1  12
--  0  3058  196:0    text  '│         '  pos: overlay  +1  12
--  0  3059  197:0    text  '│         '  pos: overlay  +1  12
--  0  3060  198:0    text  '│ │     '  pos: overlay  +1  12
--  0  3061  199:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3062  200:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3063  201:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3064  202:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3065  203:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3066  204:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3067  205:0    text  '│ │ │ │ │ │ '  pos: overlay  +1  12
--  0  3068  206:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3069  207:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3070  208:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3071  209:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3072  210:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3073  211:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3074  212:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3075  213:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3076  214:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3077  215:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3078  216:0    text  '│ │ │ │ │ '  pos: overlay  +1  12
--  0  3079  217:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3080  218:0    text  '│ │ │ │ '  pos: overlay  +1  12
--  0  3081  219:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3082  220:0    text  '│ │ │ '  pos: overlay  +1  12
--  0  3083  221:0    text  '│ │     '  pos: overlay  +1  12
--  0  3084  222:0    text  '│         '  pos: overlay  +1  12
--  0  3085  223:0    text  '│         '  pos: overlay  +1  12
--  0  3086  224:0    text  '│         '  pos: overlay  +1  12
-- nvim.nvim.lsp.lua_ls.2.diagnostic (139)       =>           2 ext
--  0  1  208:26  208:35          +nil  0
--  0  2  210:12  210:13          +nil  0
-- nvim.nvim.lsp.lua_ls.2.diagnostic.signs (140) =>           2 ext
--  0  2  208:0            +6  0
--  0  1  210:0            +6  0
-- SmoothCursor (38)                             =>           1 ext
--  0  3752  260:0    sign   smoothcursor   "▷ " SmoothCursor  +6  12

return namespaces
