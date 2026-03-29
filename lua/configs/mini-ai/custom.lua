-- stylua: ignore-start

-- stylua: ignore
-- MiniExtra.gen_ai_spec.buffer = function()
--   return function(ai_type)
--     local start_line, end_line = 1, vim.fn.line('$')
--     if ai_type == 'i' then
--       -- Skip first and last blank lines for `i` textobject
--       local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
--       -- Do nothing for buffer with all blanks
--       if first_nonblank == 0 or last_nonblank == 0 then return { from = { line = start_line, col = 1 } } end
--       start_line, end_line = first_nonblank, last_nonblank
--     end

--     local to_col = math.max(vim.fn.getline(end_line):len(), 1)
--     return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
--   end
-- end


local function find_previous_non_whitespace()
  -- Get current cursor position
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Get content of the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Iterating from the current line upwards
  for l = row - 1, 1, -1 do
    -- Get the specific line text from buffer, remember Lua is 1-indexed
    local line = lines[l]
    if line then
--     -- Extract the string before the cursor position (note col is 0-indexed in Vim)
--     local before_cursor = line:sub(1, col)
--     -- Search for the last non-whitespace character in the string before the cursor
--     local start_pos = before_cursor:match(".*()%S")
      -- String pattern to find last non-whitespace character in this line

      local s = line:match(".*()%S")
      -- local s, e = line:find("[^%s]")
      if s then
        if l == row then
          if s - 1 <= col then
            return l, s - 1
          end
        else
          -- Return the line number and column index adjusted to 0-indexed
          return l, s - 1
        end
      end
    end
  end


  -- Return nil if no non-whitespace character found before cursor position
  return nil
end

require("mapper").map({ "n" }, "<leader>W", function()
  local row, col = find_previous_non_whitespace()
  vim.dbglog(row, col)

  -- if row and col then
  --   vim.api.nvim_win_set_cursor(0, { row, col })
  -- end
end, { desc = "find previous non-whitespace" })

-- MiniExtra.gen_ai_spec.whitespace = function()
--   local whitespace_pattern = "%s"
--
--   -- create a mini.ai text object that selects surrounding whitespace
--   -- and allows for inner and outer selection
--
--   local whitespace_object = function(start_line, start_col, end_line, end_col)

-- -- --     local start_line, end_line = 1, vim.fn.line('$')
--     return { from = { line = start_line, col = start_col }, to = { line = end_line, col = end_col } }

--   -- local find_whitespace = function(line, init)
--   --   local from, to = line:find(whitespace_pattern, init)
--   --   if from == nil then
--   --     return nil, nil
--   --   end
--   --   return from, to
--   -- end

--   return function(ai_type)
--     if ai_type == "i" then
--       return { whitespace_pattern }
--     end
--     return { find_whitespace, { "^().*()$" } }
--   end
-- end

-- stylua: ignore-end
