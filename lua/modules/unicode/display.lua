local M = {}

local output_width = 1

--- Reset the output width tracker (call before a new output sequence).
function M.reset_width()
  output_width = 1
end

--- Output formatted text with highlight groups via nvim_echo.
--- Handles line wrapping based on terminal width.
--- @param ... string|table Arguments: strings to display (first gets Title highlight, rest Normal).
---                          Tables are skipped (empty). Can also pass a color_pattern for highlighting.
function M.screen_output(color_pattern, ...)
  local args = { ... }
  local items = {}
  for _, v in ipairs(args) do
    if type(v) == "string" and v ~= "" then
      items[#items + 1] = v
    end
  end

  if #items == 0 then
    return
  end

  -- Calculate total width
  local total_width = 0
  for _, item in ipairs(items) do
    total_width = total_width + vim.fn.strdisplaywidth(item)
  end

  -- Check if we need a newline
  local chunks = {}
  if output_width + total_width >= vim.o.columns then
    chunks[#chunks + 1] = { "\n", "" }
    output_width = total_width + 1
  else
    output_width = output_width + total_width
  end

  -- Build echo chunks with highlighting
  for i, value in ipairs(items) do
    local hl = i == 1 and "Title" or "Normal"

    if color_pattern and color_pattern ~= "" then
      -- Split text around the color pattern match
      local start_pos, end_pos = value:lower():find(color_pattern:lower(), 1, true)
      if start_pos then
        if start_pos > 1 then
          chunks[#chunks + 1] = { value:sub(1, start_pos - 1), hl }
        end
        chunks[#chunks + 1] = { value:sub(start_pos, end_pos), "WarningMsg" }
        if end_pos < #value then
          chunks[#chunks + 1] = { value:sub(end_pos + 1), hl }
        end
      else
        chunks[#chunks + 1] = { value, hl }
      end
    else
      chunks[#chunks + 1] = { value, hl }
    end
  end

  vim.api.nvim_echo(chunks, false, {})
end

--- Format a unicode character info line.
--- @param glyph string The character glyph
--- @param dec number Decimal codepoint
--- @param name string Unicode name
--- @param dig string|nil Digraph string
--- @param html string|nil HTML entity
--- @param info string|nil Extra info
--- @param pat string|nil Regex pattern
--- @param str string|nil String representation
--- @param nerd string|nil Nerd font info
--- @return string
function M.format_char_info(glyph, dec, name, dig, html, info, pat, str, nerd)
  local parts = { string.format("'%s' U+%04X Dec:%d", glyph, dec, dec) }

  if name and name ~= "" then
    parts[#parts + 1] = " " .. name
  end
  if dig and dig ~= "" then
    parts[#parts + 1] = " " .. dig
  end
  if html and html ~= "" then
    parts[#parts + 1] = " " .. html
  end
  if info and info ~= "" then
    parts[#parts + 1] = " " .. info
  end
  if pat and pat ~= "" then
    parts[#parts + 1] = " " .. pat
  end
  if str and str ~= "" then
    parts[#parts + 1] = " " .. str
  end
  if nerd and nerd ~= "" then
    parts[#parts + 1] = " " .. nerd
  end

  return table.concat(parts)
end

return M
