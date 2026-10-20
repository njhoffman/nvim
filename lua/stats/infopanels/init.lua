local NuiLine = require("nui.line")
local NuiText = require("nui.text")
local NuiPopup = require("nui.popup")
local event = require("nui.utils.autocmd").event

-- local NuiText = require("nui.text")
-- local text = NuiText("Something Went Wrong!", "Error")
-- local bufnr, linenr, byte_pos = 0, 1, 0
-- text:render(bufnr, linenr, byte_pos, linenr, byte_pos)

local utils = {}

---@param text string
---@param max_length number
---@return string
utils.truncate_text = function(text, max_length)
  if vim.api.nvim_strwidth(text) > max_length then
    return string.sub(text, 1, max_length - 1) .. "…"
  end

  return text
end

---@param text string
---@param align "'left'" | "'center'" | "'right'"
---@param line_length number
---@param gap_char string
---@return string
utils.align_text = function(text, align, line_length, gap_char)
  local gap_length = line_length - vim.api.nvim_strwidth(text)

  local gap_left = ""
  local gap_right = ""

  if align == "left" then
    gap_right = string.rep(gap_char, gap_length)
  elseif align == "center" then
    gap_left = string.rep(gap_char, math.floor(gap_length / 2))
    gap_right = string.rep(gap_char, math.ceil(gap_length / 2))
  elseif align == "right" then
    gap_left = string.rep(gap_char, gap_length)
  end

  return gap_left .. text .. gap_right
end

local parse_line = function(line_item)
  -- local label = NuiText(line_item.label, 'MoreMsg')
  -- local value = NuiText(line_item.value, 'Comment')
  local label = line_item.label
  local value = line_item.value

  -- local line = NuiLine({ label, value })
  -- local bufnr, linenr = 0, 1
  -- line:render(bufnr, linenr)
  local line = { utils.align_text(label, "left", 15), utils.align_text(value, "right", 8) }
  return { label, value, line }
end

function refresh_lines(lines, popup, timer_n)
  local parsed_lines = {}
  for i, line_item in pairs(lines) do
    local line_parts = {}
    line_parts.value = tostring(timer_n)
    line_parts.label = line_item[1]
    local parsed = parse_line(line_parts)
    table.insert(parsed_lines, i, parsed[3])
  end
  -- set content
  -- local select_items = {"one", "two", "three"}
  -- local select_items = { tostring(timer_n), tostring(timer_n), tostring(timer_n) }
  vim.logger:debug("PARSED")
  vim.logger:debug(vim.inspect(parsed_lines))

  vim.api.nvim_buf_set_lines(popup.bufnr, -4, -1, false, parsed_lines)
end

local new_panel = function(popup_opts, lines)
  local size = {
    width = 25,
    height = 20,
  }
  popup_opts.size = size
  local popup = NuiPopup(popup_opts)
  local timer = nil

  function open_popup()
    -- mount/open the component

    popup:mount()

    popup:on(event.BufWinLeave, function()
      print("STOPPED TIMER")
      timer:close()
    end)

    timer = vim.uv.new_timer()

    local timer_n = 0

    timer:start(
      0,
      5000,
      vim.schedule_wrap(function()
        timer_n = timer_n + 1
        if popup.popup_state.mounted == nil then
          print("STOPPED TIMER")
          timer:close()
        end
        print("timer invoked! i=" .. tostring(timer_n))
        refresh_lines(lines, popup, timer_n)
      end)
    )
    vim.dbg({ "new timer", timer_n = timer_n })

    -- refresh_lines(lines, popup, timer_n)
  end

  function close_popup()
    timer:close() -- Always close handles to avoid leaks.
    popup:unmount()
  end

  return { open = open_popup, close = close_popup }
end

local M = {}

M.setup = function(opts)
  local panels = {}
  for _, opt in pairs(opts) do
    local panel = new_panel(opt.popup, opt.lines)
    panel.name = opts.name
    table.insert(panels, panel)
  end
  return panels
end

return M
