local Flash = lambda.reqidx('flash')

local M = {}

M.search_toggle_option = function()
  Flash.toggle()
end

M.op_jump_forward = function()
  -- Flash: exact mode, multi window, all directions, with a backdrop
  Flash.jump({
    search = { forward = true, wrap = false, multi_window = false },
  })
end

M.op_jump_backward = function()
  Flash.jump({ search = { forward = false, wrap = false, multi_window = false } })
end

M.char_jump_forward = function()
  -- default options: exact mode, multi window, all directions, with a backdrop
  Flash.jump({ search = { forward = true, wrap = false, multi_window = false } })
end

M.char_jump_backward = function()
  Flash.jump({ search = { forward = false, wrap = false, multi_window = false } })
end

M.fuzzy_jump = function()
  Flash.jump({ mode = 'fuzzy' })
end

M.fuzzy_jump_select = function()
  Flash.jump({ mode = 'select' })
end

-- tree hopper thing replacement in some sense
M.op_treesitter = function()
  Flash.treesitter()
end

M.jump_current_screen = function()
  Flash.jump({ search = { mode = 'screen' } })
end

--  ╭────────────────────────────────────────────────────────────────────╮
--  │         Word Jumpers                                               │
--  ╰────────────────────────────────────────────────────────────────────╯

M.word_fuzzy_search = function()
  Flash.jump({ mode = 'fuzzy' })
end

M.word_fuzzy_select = function()
  Flash.jump({ mode = 'select' })
end

M.word_fuzzy_remote = function()
  Flash.remote({ mode = 'select' })
end

M.word_current_jump = function()
  Flash.jump({
    pattern = vim.fn.expand('<cword>'),
  })
end

M.word_current_screen = function()
  ---@param opts Flash.Format
  local function format(opts)
    -- always show first and second label
    return { { opts.match.label1, 'FlashMatch' }, { opts.match.label2, 'FlashLabel' } }
  end

  Flash.jump({
    search = { mode = 'search' },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          -- limit matches to the current label
          return vim.tbl_filter(function(m)
            return m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2 -- use the second label
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end

M.word_current_buffer = function()
  Flash.jump({
    search = {
      multi_window = true,
      mode = 'textcase',
    },
  })
end

M.word_jump_any = function()
  Flash.jump({
    pattern = '.', -- initialize pattern with any char
    search = {
      mode = function(pattern)
        -- remove leading dot
        if pattern:sub(1, 1) == '.' then
          pattern = pattern:sub(2)
        end
        -- return word pattern and proper skip pattern
        return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
      end,
    },
    -- select the range
    jump = { pos = 'range' },
  })
end

return M
