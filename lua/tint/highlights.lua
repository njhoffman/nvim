local ts_utils = require("nvim-treesitter.ts_utils")

local hl_stub = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace("error_messages")

  -- Display a multiline error message below line 30
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 30, 0, {
    virt_lines = {
      { { "Error: Null Pointer Exception encountered", "ErrorMsg" } },
      { { "Ensure variable is initialized before use", "ErrorHint" } },
    },
    virt_lines_above = false,
  })
end

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
  local highlights = { ts = {}, ext = {} }
  highlights.ts = ts_range_highlights(bufnr, range)
  highlights.ext = vim.api.nvim_buf_get_extmarks(
    bufnr,
    -1,
    { range[1], 0 },
    { range[3], range[4] },
    { details = true, overlap = true, type = "highlight" }
  )

  return text, highlights
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
  local highlights = { ts = {}, ext = {} }
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

  -- [61] = { anon = "chunk", name = "boolean", range = { [1] = 51, [2] = 73, [3] = 51, [4] = 76, n = 4 }, text = "true" },
  for _, hl in ipairs(highlights.ts) do
  end
  -- vim.api.nvim_buf_set_extmark(bufnr, ns_id, line, col, opts)

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
end

local state = { buffers = {} }
local ns_pfx = "_tint_"

local buffer_overlay = function(bufnr, range, opts)
  bufnr = bufnr and bufnr ~= 0 and bufnr or vim.api.nvim_get_current_buf()
  opts = opts or {}
  state.buffers[bufnr] = state.buffers[bufnr] or { head = {}, middle = {}, tail = {} }
  local ns_prefix = ns_pfx .. bufnr .. "_" .. opts.name or "overlay" .. "_"

  local ns_prevs = vim.tbl_filter(function(ns_name)
    return string.match(ns_name, ns_prefix)
  end, vim.tbl_keys(vim.api.nvim_get_namespaces()))

  vim.dbglog("prev", ns_prevs)
  local ns_name = string.format("%s%s", ns_prefix, #ns_prevs + 1)
  local ns_id = vim.api.nvim_create_namespace(ns_name)

  local buf_range = parse_range(range[1], range[2])
  local text, hls = buffer_range_highlights(bufnr, buf_range)

  return ns_name, buf_range, hls
end

return { buffer_overlay = buffer_overlay }
