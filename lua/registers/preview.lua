local state = require('registers.state')
local config = require('registers.config')

---@private
---Get the register information matching the register.
---@param register? string Register to look up, if nothing is passed the current line will be used
---@return? table Register information from `registers._register_values`
local _register_info = function(register)
  if register == nil then
    -- A register is selected by the cursor, get it based on the current line
    local cursor = unpack(vim.api.nvim_win_get_cursor(state._window))

    return state._register_values[cursor]
  else
    -- Otherwise find it by looking up the register in the list
    for i = 1, #state._register_values do
      if state._register_values[i].register == register then
        return state._register_values[i]
      end
    end
  end

  return nil
end

local highlight_lines = function(lines)
  local options = config.get()
  local hl_group = vim.tbl_get(options, 'sign_highlights', 'register_preview') or 'Normal'
  local hl_lines = {}
  for _, line in ipairs(lines) do
    local line_parts = { line, hl_group }
    table.insert(hl_lines, { line_parts })
  end
  -- *vim.lsp.util.convert_input_to_markdown_lines()*
  return hl_lines
end

---Show a preview of the highlighted register in the target buffer.
---Currently this overlays the text, waiting for https://github.com/neovim/neovim/pull/9496 to merge.
---@param options callback_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
local preview_register = function(options)
  local utils = require('registers.utils')
  return utils._handle_callback_options(options --[[@as callback_options]], function()
    -- Get the register contents for the current line as a table
    local register_info = _register_info()

    -- Do nothing when an invalid line is selected
    if type(register_info) ~= 'table' then
      return
    end

    local register_lines = register_info.regcontents

    -- Add the highlight to the lines
    local lines = highlight_lines(register_lines)

    -- Clear the previous extmarks
    vim.api.nvim_buf_clear_namespace(state._preview_buffer, state._namespace, 0, -1)

    -- Get the cursor position of the main buffer
    local line, col = unpack(vim.api.nvim_win_get_cursor(state._preview_window))

    vim.api.nvim_buf_set_extmark(
      state._preview_buffer,
      state._namespace,
      line - 1,
      col,
      { virt_lines = lines }
      -- { virt_text = lines, virt_text_win_col = col }
    )
    -- if #lines == 1 then
    --   -- Display the register content
    --   vim.api.nvim_buf_set_extmark(
    --     state._preview_buffer,
    --     state._namespace,
    --     line - 1,
    --     col,
    --     { virt_text = lines, virt_text_win_col = col }
    --   )
    -- else
    --   -- Display the register content
    -- end
  end)
end
-- • virt_lines : virtual lines to add next to this mark This
--   should be an array over lines, where each line in turn is
--   an array over [text, highlight] tuples. In general, buffer
--   and window options do not affect the display of the text.
--   In particular 'wrap' and 'linebreak' options do not take
--   effect, so the number of extra screen lines will always
--   match the size of the array. However the 'tabstop' buffer
--   option is still used for hard tabs. By default lines are
--   placed below the buffer line containing the mark.
-- • virt_lines_above: place virtual lines above instead.
-- • virt_lines_leftcol: Place extmarks in the leftmost column
--   of the window, bypassing sign and number columns.

return { preview_register = preview_register }
