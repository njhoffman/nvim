local M = {}

local color_math = require("configs.vimade.color_math")

local ns = vim.api.nvim_create_namespace("vimade_range_hl")

-- Active ranges per buffer.
-- { [bufnr] = { restore = { {start_row, start_col, end_row, end_col}, ... },
--               transform = { {start_row, start_col, end_row, end_col, transforms}, ... } } }
local active_ranges = {}

-- Visual mode state.
local visual_restore_enabled = false
local visual_timer = nil
local VISUAL_DELAY_MS = 50

-- Get treesitter highlights for a buffer range (adapted from scratch/tmp7.lua).
local function ts_range_highlights(bufnr, top, bottom)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return {}
  end
  local trees = parser:parse()
  if not trees or not trees[1] then
    return {}
  end

  local lang = vim.bo[bufnr].filetype
  local qok, query = pcall(vim.treesitter.query.get, lang, "highlights")
  if not qok or not query then
    return {}
  end

  local highlights = {}
  local root = trees[1]:root()
  for id, node, _ in query:iter_captures(root, bufnr, top, bottom + 1) do
    local name = "@" .. query.captures[id]
    local srow, scol, erow, ecol = node:range()
    if srow >= top and erow <= bottom then
      highlights[#highlights + 1] = {
        hl_group = name,
        start_row = srow,
        start_col = scol,
        end_row = erow,
        end_col = ecol,
      }
    end
  end
  return highlights
end

-- Get existing extmark highlights in a range.
local function extmark_range_highlights(bufnr, top, bottom)
  local ok, extmarks = pcall(
    vim.api.nvim_buf_get_extmarks,
    bufnr,
    -1,
    { top, 0 },
    { bottom, -1 },
    { details = true, overlap = true, type = "highlight" }
  )
  if not ok then
    return {}
  end

  local highlights = {}
  for _, mark in ipairs(extmarks) do
    local details = mark[4]
    if details and details.hl_group then
      -- Skip vimade's own extmarks and our own namespace.
      local mark_ns = details.ns_id
      if mark_ns ~= ns then
        highlights[#highlights + 1] = {
          hl_group = details.hl_group,
          start_row = mark[2],
          start_col = mark[3],
          end_row = details.end_row or mark[2],
          end_col = details.end_col or mark[3],
        }
      end
    end
  end
  return highlights
end

-- Check if two ranges overlap.
local function ranges_overlap(a_sr, a_sc, a_er, a_ec, b_sr, b_sc, b_er, b_ec)
  if a_er < b_sr or b_er < a_sr then
    return false
  end
  if a_er == b_sr and a_ec <= b_sc then
    return false
  end
  if b_er == a_sr and b_ec <= a_sc then
    return false
  end
  return true
end

-- Get the visual selection range (0-indexed).
local function get_visual_range()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end

  local vpos = vim.fn.getpos("v")
  local cpos = vim.fn.getpos(".")
  local sr, sc = vpos[2] - 1, vpos[3] - 1
  local er, ec = cpos[2] - 1, cpos[3]

  -- Normalize so start <= end.
  if sr > er or (sr == er and sc > ec) then
    sr, sc, er, ec = er, ec - 1, sr, sc + 1
  end

  if mode == "V" then
    sc = 0
    ec = -1 -- line-wise: to end of line
  end

  return { sr, sc, er, ec }
end

-- Set ephemeral restore extmarks for a range using treesitter + extmark highlights.
local function apply_restore(bufnr, top, bottom, range)
  local sr, sc, er, ec = range[1], range[2], range[3], range[4]

  -- Clamp to visible area.
  local vis_sr = math.max(sr, top)
  local vis_er = math.min(er, bottom)

  -- Get original highlights from treesitter.
  local ts_hls = ts_range_highlights(bufnr, vis_sr, vis_er)
  for _, hl in ipairs(ts_hls) do
    if ranges_overlap(hl.start_row, hl.start_col, hl.end_row, hl.end_col, sr, sc, er, ec) then
      -- Clamp highlight to the restore range.
      local hl_sr = math.max(hl.start_row, sr)
      local hl_sc = hl.start_row == sr and math.max(hl.start_col, sc) or hl.start_col
      local hl_er = math.min(hl.end_row, er)
      local hl_ec = hl.end_row == er and (ec == -1 and hl.end_col or math.min(hl.end_col, ec))
        or hl.end_col

      pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, hl_sr, hl_sc, {
        end_row = hl_er,
        end_col = hl_ec,
        hl_group = hl.hl_group,
        ephemeral = true,
        priority = 4097,
      })
    end
  end

  -- Also restore extmark-based highlights (from other plugins).
  local ext_hls = extmark_range_highlights(bufnr, vis_sr, vis_er)
  for _, hl in ipairs(ext_hls) do
    if ranges_overlap(hl.start_row, hl.start_col, hl.end_row, hl.end_col, sr, sc, er, ec) then
      local hl_sr = math.max(hl.start_row, sr)
      local hl_sc = hl.start_row == sr and math.max(hl.start_col, sc) or hl.start_col
      local hl_er = math.min(hl.end_row, er)
      local hl_ec = hl.end_row == er and (ec == -1 and hl.end_col or math.min(hl.end_col, ec))
        or hl.end_col

      pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, hl_sr, hl_sc, {
        end_row = hl_er,
        end_col = hl_ec,
        hl_group = hl.hl_group,
        ephemeral = true,
        priority = 4098,
      })
    end
  end
end

-- Set ephemeral transform extmarks for a range.
local function apply_transform(bufnr, top, bottom, range_entry)
  local sr, sc, er, ec = range_entry[1], range_entry[2], range_entry[3], range_entry[4]
  local transforms = range_entry[5]

  local vis_sr = math.max(sr, top)
  local vis_er = math.min(er, bottom)

  local ts_hls = ts_range_highlights(bufnr, vis_sr, vis_er)
  for _, hl in ipairs(ts_hls) do
    if ranges_overlap(hl.start_row, hl.start_col, hl.end_row, hl.end_col, sr, sc, er, ec) then
      local derived = color_math.get_derived_hl(hl.hl_group, transforms)
      local hl_sr = math.max(hl.start_row, sr)
      local hl_sc = hl.start_row == sr and math.max(hl.start_col, sc) or hl.start_col
      local hl_er = math.min(hl.end_row, er)
      local hl_ec = hl.end_row == er and (ec == -1 and hl.end_col or math.min(hl.end_col, ec))
        or hl.end_col

      pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, hl_sr, hl_sc, {
        end_row = hl_er,
        end_col = hl_ec,
        hl_group = derived,
        ephemeral = true,
        priority = 4097,
      })
    end
  end
end

-- Decoration provider on_win callback.
local function on_win(_, _winid, bufnr, top, bottom)
  local buf_ranges = active_ranges[bufnr]
  local has_ranges = buf_ranges
    and (
      (buf_ranges.restore and #buf_ranges.restore > 0)
      or (buf_ranges.transform and #buf_ranges.transform > 0)
    )

  local visual_range = nil
  if visual_restore_enabled then
    local cur_buf = vim.api.nvim_get_current_buf()
    if cur_buf == bufnr then
      visual_range = get_visual_range()
    end
  end

  if not has_ranges and not visual_range then
    return false
  end

  -- Apply explicit restore ranges.
  if buf_ranges and buf_ranges.restore then
    for _, range in ipairs(buf_ranges.restore) do
      apply_restore(bufnr, top, bottom, range)
    end
  end

  -- Apply explicit transform ranges.
  if buf_ranges and buf_ranges.transform then
    for _, range_entry in ipairs(buf_ranges.transform) do
      apply_transform(bufnr, top, bottom, range_entry)
    end
  end

  -- Apply visual selection restore.
  if visual_range then
    apply_restore(bufnr, top, bottom, visual_range)
  end
end

-- Register the decoration provider.
vim.api.nvim_set_decoration_provider(ns, {
  on_win = on_win,
})

-- Mark a range in a buffer for original-highlight restoration.
-- Positions are 0-indexed: {start_row, start_col, end_row, end_col}.
M.restore_range = function(bufnr, start_row, start_col, end_row, end_col)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not active_ranges[bufnr] then
    active_ranges[bufnr] = { restore = {}, transform = {} }
  end
  active_ranges[bufnr].restore[#active_ranges[bufnr].restore + 1] =
    { start_row, start_col, end_row, end_col }
end

-- Clear all restore ranges for a buffer.
M.clear_restore = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if active_ranges[bufnr] then
    active_ranges[bufnr].restore = {}
  end
end

-- Apply a color transform to a range.
-- `transforms` is a table like { lighten = 0.2, darken = 0.1, saturate = 0.3, hue = 90 }.
M.transform_range = function(bufnr, start_row, start_col, end_row, end_col, transforms)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not active_ranges[bufnr] then
    active_ranges[bufnr] = { restore = {}, transform = {} }
  end
  active_ranges[bufnr].transform[#active_ranges[bufnr].transform + 1] =
    { start_row, start_col, end_row, end_col, transforms }
end

-- Clear all transform ranges for a buffer.
M.clear_transforms = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if active_ranges[bufnr] then
    active_ranges[bufnr].transform = {}
  end
end

-- Clear all ranges (restore + transform) for a buffer.
M.clear_all = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  active_ranges[bufnr] = nil
end

-- Enable visual mode auto-restore with 50ms delay.
M.enable_visual_restore = function()
  if visual_restore_enabled then
    return
  end
  visual_restore_enabled = false -- starts disabled, activated by timer

  local augroup = vim.api.nvim_create_augroup("vimade_visual_restore", { clear = true })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    pattern = "*:[vV\x16]*",
    callback = function()
      if visual_timer then
        visual_timer:stop()
      end
      visual_timer = vim.defer_fn(function()
        visual_restore_enabled = true
        vim.cmd.redraw()
      end, VISUAL_DELAY_MS)
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    pattern = "[vV\x16]*:*",
    callback = function()
      if visual_timer then
        visual_timer:stop()
        visual_timer = nil
      end
      visual_restore_enabled = false
    end,
  })
end

-- Disable visual mode auto-restore.
M.disable_visual_restore = function()
  visual_restore_enabled = false
  if visual_timer then
    visual_timer:stop()
    visual_timer = nil
  end
  pcall(vim.api.nvim_del_augroup_by_name, "vimade_visual_restore")
end

-- Clean up ranges for deleted buffers.
M._cleanup = function()
  for bufnr, _ in pairs(active_ranges) do
    if not vim.api.nvim_buf_is_valid(bufnr) then
      active_ranges[bufnr] = nil
    end
  end
end

-- Expose state for debugging.
M._active_ranges = function()
  return active_ranges
end

return M
