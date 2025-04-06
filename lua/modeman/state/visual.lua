local ns = require("modeman.namespace")
local ns_op = vim.api.nvim_create_namespace("modeman/visual")

local visual_state = function(curr)
  -- visual range:
  --   when it is "V" (visual line mode) the column of '< is zero and the column of '> is a large number equal to |v:maxcol|.
  --   A very large column number equal to |v:maxcol| can be returned, in which case it means "after the end of the line".
  if vim.api.nvim_buf_is_valid(curr.buf) then
    local start_pos = vim.fn.getpos(".")
    local end_pos = vim.fn.getpos("v")
    local winid = vim.fn.bufwinid(curr.buf)
    local virtualedit =
      vim.api.nvim_get_option_value("virtualedit", { scope = "local", win = winid })
    -- virtualedit:
    --   block/insert/all  Allow virtual editing in Visual block / Insert / all mode.
    --   onemore           Allow the cursor to move just past the end of the line
    --   none/NONE         When used as the local value, do not allow virtual editing even when the global value is set. When used as the global value, "none" is the same as "".
    local selection = vim.api.nvim_get_option_value("selection", { scope = "global" })
    local visualmode = vim.fn.mode() == "v" and "charwise"
      or vim.fn.mode() == "V" and "linewise"
      or "blockwise"

    -- vim.dbglog("vis state", start_pos, end_pos)
    -- if start_pos[1] ~= 0 or end_pos[1] ~= 0 or start_pos[4] ~= 0 or end_pos[4] ~= 0 then
    --   vim.dbglog("VISUAL STATE", state, start_pos, end_pos)
    -- end

    return {
      range_from = start_pos[2] .. ":" .. start_pos[3],
      range_to = end_pos[2] .. ":" .. end_pos[3],
      virtualedit = virtualedit ~= "" and virtualedit or nil,
      visualmode = visualmode,
      selection = selection,
    }
  end
end

local vis_cursor_move = function(ev)
  local vis_state = visual_state()
  -- vim.dbglog("visual to:   " .. vim.inspect(vis_state, { newline = ",", indent = "  " }))
  return vis_state
end

local mode_from = function(curr)
  -- vim.api.nvim_buf_clear_namespace(state.curr.buf, ns_vis, 0, -1)
  -- vim.dbglog("visual from: " .. vim.inspect(curr, { newline = ",", indent = "  " }))
  -- vim.dbglog("end", ev.buf)
end

local mode_to = function(curr)
  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = vis_cursor_move,
    group = ns.augroup_id,
    desc = "cursor move in visual mode",
    buffer = curr.buf,
  })

  return vis_state
  -- highlight number signs for lines inlucded in visual range
  -- for i = start_pos[2], end_pos[2], 1 do
  --   -- highlightt number column extmarks
  --   local bars = { thick = "▎", thin = "│" }
  --   -- vim.dbglog("vis", ev.buf, i, end_pos[2])
  --   vim.api.nvim_buf_set_extmark(ev.buf, ns_vis, i, 0, {
  --     -- virt_text = { { " " .. i .. " ", "SmoothCursor" } },
  --     -- virt_text_pos = "overlay",
  --     hl_mode = "combine",
  --     sign_text = bars.thick,
  --     sign_hl_group = "Visual",
  --     number_hl_group = "Visual",
  --   })
  -- end
end
-- 10:34:47  modeman:    n:no   'g@'   [gs] `split/join content `
-- 10:34:48  modeman:   no:n    'y'            3: 35:0   -  38:  8:0
-- 10:34:48  modeman:   no:n    'y'          123:135:0   - 338:128:5

local is_visual = function(mode)
  if type(mode) ~= "string" or mode == "" then
    return false
  end
  mode = vim.api.nvim_replace_termcodes(mode, true, false, true)
  local vismode = vim.fn.tolower(string.sub(mode, 1))
  return vismode == "v" or vismode == ""
end

local parse_key = function(typed, keymap)
  local parse = function(key)
    return { key, vim.fn.keytrans(key), vim.fn.strtrans(key) }
  end
  local parsed = {
    typed = parse(typed),
    keymap = parse(keymap),
  }
  vim.dbglog(parsed.typed, parsed.keymap)
  -- vim.dbglog(string.format("%5s  %s", parsed.typed[3], parsed.keymap[3]))
end

local key_state = { typed = nil, keys = {} }
local onkey = function(keymap, typed)
  -- key is after mappings applied, typed is before mappings applied
  parse_key(typed, keymap)
  -- if key == '\27' then was_cancelled = true end
  -- if type(trans.key) == "string" and #trans.key > 0 then
  --   if type(trans.typed) == "string" and #trans.typed > 0 then
  --     key_state.typed = trans.typed
  --     table.insert(key_state.keys, trans.typed)
  --   else
  --     table.insert(key_state.keys, trans.key)
  --   end
  -- end
end

local get_state = function(curr)
  local vis_state = {}
  if is_visual(curr.mode) then
    -- mode_to(curr)
    vis_state = {}
    vim.on_key(onkey, ns_op)
  elseif is_visual(curr.from) then
    vim.on_key(nil, ns_op)
    if type(key_state.typed) == "string" and #key_state.typed > 0 then
      vis_state = vim.tbl_deep_extend("force", vis_state, key_state)
    end
    key_state = { typed = nil, keys = {} }
    --   vis_state = mode_to(curr)
  end
  if vim.fn.empty(vis_state) == 0 then
    vim.dbglog("vis", vis_state.typed, vis_state.keys)
  end
  return vis_state
end
return { get_state = get_state }
