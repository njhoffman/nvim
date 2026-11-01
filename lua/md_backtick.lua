-- md_backtick: toggle backticks around a visual selection in Markdown.
-- A charwise selection within one line gets inline `code`; a linewise selection, or one that
-- spans lines, gets a ``` fence around the whole lines. Pressing it on a wrapped selection
-- unwraps it (the outer span or fence; otherwise every backtick in the selection) and keeps
-- the selection, so the key toggles.
local M = {}

local FENCE_OPEN = "^%s*```[^`]*$"
local FENCE_CLOSE = "^%s*```%s*$"

local function notify(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "Backticks" })
end

--- Select a charwise range (1-based rows, 0-based byte cols, end inclusive).
local function select_chars(row, scol, erow, ecol)
  vim.api.nvim_win_set_cursor(0, { row, scol })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { erow, math.max(ecol, scol) })
end

--- Select whole lines (1-based rows).
local function select_lines(srow, erow)
  vim.api.nvim_win_set_cursor(0, { srow, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { erow, 0 })
end

--- Content of a single code span (`x`, ``x`y``), or nil if text isn't exactly one span: the
--- inner text must not hold a backtick run as long as the outer one, which would close it.
--- @param text string
--- @return string|nil
function M.span_content(text)
  local ticks = text:match("^(`+)")
  if not ticks or #text <= 2 * #ticks or text:sub(-#ticks) ~= ticks then
    return nil
  end
  local inner = text:sub(#ticks + 1, -#ticks - 1)
  if inner:find("^`") or inner:find("`$") then
    return nil
  end
  for run in inner:gmatch("`+") do
    if #run == #ticks then
      return nil
    end
  end
  return inner
end

--- Toggle inline backticks on bytes scol..ecol (1-based, inclusive) of one line.
--- @return string action "wrapped" | "unwrapped" | "stripped"
local function toggle_inline(buf, row, scol, ecol)
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
  local sel = line:sub(scol, ecol)
  if sel == "" then
    return "empty"
  end
  local before, after = line:sub(1, scol - 1), line:sub(ecol + 1)

  local new, action
  local inner = M.span_content(sel)
  if inner then
    new, action = inner, "unwrapped"
  elseif sel:find("`", 1, true) then
    new, action = sel:gsub("`", ""), "stripped"
  else
    new, action = "`" .. sel .. "`", "wrapped"
  end

  vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { before .. new .. after })
  if #new == 0 then
    vim.api.nvim_win_set_cursor(0, { row, math.max(scol - 1, 0) })
  else
    select_chars(row, scol - 1, row, scol - 1 + #new - 1)
  end
  return action
end

--- Toggle a fence around lines srow..erow (1-based, inclusive).
--- @return string action
local function toggle_block(buf, srow, erow)
  local lines = vim.api.nvim_buf_get_lines(buf, srow - 1, erow, false)

  if #lines >= 2 and lines[1]:find(FENCE_OPEN) and lines[#lines]:find(FENCE_CLOSE) then
    local inner = vim.list_slice(lines, 2, #lines - 1)
    vim.api.nvim_buf_set_lines(buf, srow - 1, erow, false, inner)
    if #inner > 0 then
      select_lines(srow, srow + #inner - 1)
    end
    return "unwrapped"
  end

  local has_ticks = false
  for _, l in ipairs(lines) do
    if l:find("`", 1, true) then
      has_ticks = true
      break
    end
  end

  if has_ticks then
    local kept = {}
    for _, l in ipairs(lines) do
      if not l:find(FENCE_OPEN) then
        kept[#kept + 1] = (l:gsub("`", ""))
      end
    end
    vim.api.nvim_buf_set_lines(buf, srow - 1, erow, false, kept)
    if #kept > 0 then
      select_lines(srow, srow + #kept - 1)
    end
    return "stripped"
  end

  local indent = ""
  for _, l in ipairs(lines) do
    if l:find("%S") then
      indent = l:match("^%s*")
      break
    end
  end
  local fence = indent .. "```"
  local wrapped = { fence }
  vim.list_extend(wrapped, lines)
  wrapped[#wrapped + 1] = fence
  vim.api.nvim_buf_set_lines(buf, srow - 1, erow, false, wrapped)
  select_lines(srow, erow + 2)
  return "wrapped"
end

local MESSAGES = {
  unwrapped = "Removed backticks",
  stripped = "Removed all backticks in the selection",
}

--- Toggle backticks around the current visual selection.
--- @return string|nil action "wrapped" | "unwrapped" | "stripped"
function M.toggle()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end
  local region = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
  if #region == 0 then
    return nil
  end
  local first, last = region[1], region[#region]
  local srow, erow = first[1][2], last[2][2]
  local buf = vim.api.nvim_get_current_buf()

  vim.cmd("normal! \27")
  local action
  if mode == "v" and srow == erow then
    action = toggle_inline(buf, srow, first[1][3], last[2][3])
  else
    action = toggle_block(buf, srow, erow)
  end
  if MESSAGES[action] then
    notify(MESSAGES[action])
  end
  return action
end

--- Map ` in visual mode for the given buffer.
--- @param buf integer
function M.attach(buf)
  vim.keymap.set(
    "x",
    "`",
    M.toggle,
    { buffer = buf, desc = "Toggle backticks (code span / fence)" }
  )
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MdBacktick", { clear = true }),
    pattern = "markdown",
    callback = function(args)
      M.attach(args.buf)
    end,
  })
end

return M
