local ts_utils = require("nvim-treesitter.ts_utils")
local tint = require("tint")

local total_width = 20
local excluded_ft = {
  "DiffviewFileHistory",
  "DiffviewFiles",
  "DressingInput",
  "Navbuddy",
  "NeogitPopup",
  "NeogitStatus",
  "NvimTree",
  "Outline",
  "OverseerList",
  "TelescopePrompt",
  "alpha",
  "better_term",
  "checkhealth",
  "dashboard",
  "fugitiveblame",
  "lazy",
  "lspsagafinder",
  "mason",
  "neo-tree",
  "noice",
  "notify",
  "packer",
  "plugin",
  "registers",
  "saga_codeaction",
  "sagafinder",
  "sagarename",
  "spectre_panel",
  "starter",
  "startuptime",
  "toggleterm",
  "zsh",
}
local exclued_hls = { "WinSeparator", { "lualine_.*", glob = true } }

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

local setup_tint = function(cfg)
  cfg = cfg or {}
  local winid = vim.api.nvim_get_current_win()
  local bufid = vim.fn.winbufnr(winid)
  vim.dbglog(string.rep("-", total_width, ""))
  local msg = "tint setup " .. tostring(winid) .. ":" .. tostring(bufid)
  local spacers = string.rep(" ", math.ceil((total_width - #msg) / 2))
  vim.dbglog(spacers .. msg .. spacers)
  tint.setup(cfg)
end

local toggle_tint = function(winid)
  winid = winid or vim.api.nvim_get_current_win()
  vim.dbglog(string.rep("-", total_width, ""))
  local bufid = vim.fn.winbufnr(winid)
  local is_tinted = tint.is_tinted(winid)
  if is_tinted then
    local msg = "untinting " .. tostring(winid) .. ":" .. tostring(bufid)
    local spacers = string.rep(" ", math.ceil((total_width - #msg) / 2))
    vim.dbglog(spacers .. msg .. spacers)
    tint.untint(winid)
  else
    local msg = "tinting " .. tostring(winid) .. ":" .. tostring(bufid)
    local spacers = string.rep(" ", math.ceil((total_width - #msg) / 2))
    vim.dbglog(spacers .. msg .. spacers)
    tint.tint(winid)
  end
  list_namespaces({ filter = { has_hls = true, has_leaked = false }, sort = "name" })
end

local tint_cfg = {
  tint = -45, -- Darken colors, use a positive value to brighten
  saturation = 0.6, -- Saturation to preserve
  focus_change_events = nil,
  -- focus_change_events = { focus = { "WinEnter" }, unfocus = { "WinLeave" }, },
  --   transforms = require("tint.transforms").saturate(0.5),
  --   transforms = {
  --     require("tint.transforms").saturate(0.5),
  --     function(r, g, b, hl_group_info)
  --       print("Higlight group name: " .. hl_group_info.hl_group_name)
  --
  --       local hl_def = vim.api.nvim_get_hl_by_name(hl_group_info.hl_group_name)
  --       print("Highlight group definition: " .. vim.inspect(hl_def))
  --
  --       return r + 1, g + 1, b + 1
  --     end
  --   }
  --   transforms = {
  --     require("tint.transforms").tint_with_threshold(-100, "#1C1C1C", 150),  -- Try to tint by `-100`, but keep all colors at least `150` away from `#1C1C1C`
  --     require("tint.transforms").saturate(0.5),
  --   }
  --   highlight_ignore_patterns = { "WinSeparator", "Status.*" }, -- Highlight group patterns to ignore, see `string.find`
  --   window_ignore_function = function(winid)
  --     local bufid = vim.api.nvim_win_get_buf(winid)
  --     local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
  --     -- local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
  --     return buftype == "terminal"
  --   end,
}

list_namespaces({ filter = { has_hls = true, has_leaked = false }, sort = "name" })
setup_tint(tint_cfg)

list_namespaces({ filter = { has_hls = true, has_leaked = false }, sort = "name" })
vim.keymap.set("n", "<F10>", toggle_tint, { noremap = true, nowait = true })
vim.keymap.set("n", "<F12>", tint.debuginfo, { noremap = true, nowait = true })

-- get highlights from a buffer range
local function ts_range_highlights(bufnr, buf_range)
  local parser = vim.treesitter.get_parser(bufnr)
  local root_tree = parser:parse()[1]
  local root = root_tree:root()

  local range = vim.deepcopy(buf_range)
  -- -- Adjust range to be 0-indexed and include given end position
  range[3] = range[3] + 1
  local anonymous_node = root:descendant_for_range(range[1], range[2], range[3], range[4])

  local lang = vim.api.nvim_get_option_value("ft", { buf = bufnr })
  local query = vim.treesitter.query.get(lang, "highlights")
  local highlights = {}

  for pattern_id, match, metadata in
    query:iter_matches(root, bufnr, range[1], range[3], { all = true })
  do
    for id, nodes in pairs(match) do
      local name = query.captures[id]
      for _, node in ipairs(nodes) do
        local node_data = metadata[id] -- Node level metadata
        local node_range = table.pack(ts_utils.get_vim_range({ node:range() }, bufnr))
        if
          (range[1] <= 0 or node_range[1] >= range[1])
          and (range[2] <= 0 or node_range[2] <= range[2])
          and (range[3] <= 0 or node_range[3] <= range[3])
          and (range[4] <= 0 or node_range[4] >= range[4])
        then -- Check if node is within range
          -- local srow, scol, erow, ecol = table.unpack(node_range)
          -- local text = vim.api.nvim_buf_get_text(bufnr, srow - 1, scol - 1, erow - 1, ecol, {})
          local node_text = vim.treesitter.get_node_text(node, bufnr)
          local anon = anonymous_node:type()
          table.insert(highlights, {
            name = name,
            range = node_range,
            anon = anon,
            -- id = id,
            -- pattern_id = pattern_id,
            -- full_path = full_path,
            -- node_text = vim.treesitter.get_node_text(node, bufnr),
            metadata = node_data,
            text = node_text,
          })
        end
      end
    end
  end
  return highlights
end

local parse_range = function(start_pos, end_pos)
  start_pos = type(start_pos) == "number" and { start_pos, 0 }
    or type(start_pos) == "table" and start_pos
    or { 0, 0 }
  end_pos = type(end_pos) == "number" and { end_pos, 0 }
    or type(end_pos) == "table" and end_pos
    or { -1, -1 }

  local range = {
    math.max(start_pos[1] - 1, 0),
    math.max(start_pos[2] - 1, 0),
    math.max(end_pos[1] - 1, -1),
    end_pos[2] == 0 and -1 or end_pos[2],
  }
  return range
end

local buffer_range_highlights = function(bufnr, range)
  bufnr = bufnr or 0

  -- local ns_id = vim.api.nvim_get_hl_ns({ winid = winid })
  local text = vim.api.nvim_buf_get_text(bufnr, range[1], range[2], range[3], range[4], {})
  local highlights = {
    ts = {},
    ext = {},
  }
  highlights.ts = ts_range_highlights(bufnr, range)
  highlights.ext = vim.api.nvim_buf_get_extmarks(
    bufnr,
    -1,
    { range[1], 0 },
    { range[3], range[4] },
    { details = true, overlap = true, type = "highlight" }
  )

  return highlights
end

local build_virtual_text = function(bufnr, range, highlights)
  bufnr = bufnr or 0
  local virt_text = {}
  for _, hl in ipairs(highlights.ts) do
  end

  -- • id : id of the extmark to edit.
  -- • end_row : ending line of the mark, 0-based inclusive.
  -- • end_col : ending col of the mark, 0-based exclusive.
  -- • hl_group : name of the highlight group used to highlight this mark.
  -- • hl_eol : when true, for a multiline highlight covering the EOL of a line, continue the highlight for the rest of the screen line (just like for diff and cursorline highlight).
  -- • virt_text : virtual text to link to this mark.
  --     A list of `[text, highlight]` tuples, each representing a text chunk with specified highlight.
  --     `highlight` element can either be a single highlight group, or an array of multiple
  --     highlight groups that will be stacked (highest priority last). A highlight group can be supplied
  --     either as a string or as an integer, the latter which can be obtained using `nvim_get_hl_id_by_name()`.
  -- • virt_text_pos : position of virtual text. Possible values:
  --   • "eol": right after eol character (default).
  --   • "overlay": display over the specified column, without shifting the underlying text.
  --   • "right_align": display right aligned in the window.
  --   • "inline": display at the specified column, and shift the buffer text to the right as needed.
  --   • virt_text_win_col : position the virtual text at a fixed window column (starting from the first text column of the screen line) instead of "virt_text_pos".
  -- • virt_text_hide : hide the virtual text when the background text is selected or hidden because of scrolling with 'nowrap' or 'smoothscroll'. Currently only affects "overlay" virt_text.
  -- • virt_text_repeat_linebreak : repeat the virtual text on wrapped lines.
  --   • hl_mode : control how highlights are combined with the highlights of the text. Currently only affects virt_text highlights, but might affect `hl_group` in later versions.
  --   • "replace": only show the virt_text color. This is the default.
  --   • "combine": combine with background text color.
  --   • "blend": blend with background text color. Not supported for "inline" virt_text.
  -- • ephemeral : for use with `nvim_set_decoration_provider()` callbacks. The mark will only be used for the current redraw cycle, and not be permantently stored in the buffer.
  -- • right_gravity : boolean that indicates the direction the extmark will be shifted in when new text is inserted (true for right, false for left). Defaults to true.
  -- • end_right_gravity : boolean that indicates the direction the extmark end position (if it exists) will be shifted in when new text is inserted (true for right, false for left). Defaults to false.
  -- • undo_restore : Restore the exact position of the mark if text around the mark was deleted and then restored by undo. Defaults to true.
  --  • invalidate : boolean that indicates whether to hide the extmark if the entirety of its range is deleted.
  --     For hidden marks, an "invalid" key is added to the "details" array of `nvim_buf_get_extmarks()` and family. If "undo_restore" is false, the extmark is deleted instead.
  --  • priority: a priority value for the highlight group, sign attribute or virtual text. For virtual text, item with highest priority is drawn last. For example treesitter highlighting uses a value of 100.
  --  • strict: boolean that indicates extmark should not be placed if the line or column value is past the end of the buffer or end of the line respectively. Defaults to true.
  --  • sign_text: string of length 1-2 used to display in the sign column.
  --  • sign_hl_group: name of the highlight group used to highlight the sign column text.
  --  • number_hl_group: name of the highlight group used to highlight the number column.
  --  • line_hl_group: name of the highlight group used to highlight the whole line.
  --  • cursorline_hl_group: name of the highlight group used to highlight the sign column text when the cursor is on the same line as the mark and 'cursorline' is enabled.
  --  • conceal: string which should be either empty or a single character. Enable concealing similar to `:syn-conceal`. When a character is supplied it is used as `:syn-cchar`.
  --   "hl_group" is used as highlight for the cchar if provided, otherwise it defaults to `hl-Conceal`.
  --  • spell: boolean indicating that spell checking should be performed within this extmark
  --  • ui_watched: boolean that indicates the mark should be drawn by a UI. When set, the UI will receive win_extmark events. Note: the mark is positioned by virt_text attributes. Can be used together with virt_text.
  --  • url: A URL to associate with this extmark. In the TUI, the OSC 8 control sequence is used to generate a clickable hyperlink to this URL.

  -- vim.api.nvim_buf_set_extmark(bufnr, ns_id, line, col, opts)
end

local bufnr = vim.api.nvim_get_current_buf()
local buf_range = parse_range({ 45, 0 }, { 46, 0 })
-- local buf_range = parse_range(0, -1)
local hls = buffer_range_highlights(bufnr, buf_range)
build_virtual_text(bufnr, buf_range, hls)

-- buffer_content(0, 0, -1)
