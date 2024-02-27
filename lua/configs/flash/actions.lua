local function _helper(start, finish, op)
  vim.api.nvim_win_set_cursor(0, start)
  vim.cmd('normal! v')
  vim.api.nvim_win_set_cursor(0, finish)
  vim.api.nvim_feedkeys(op or 'p', 'ni', false)
end

local _swap_with = function(opts, ma, mb)
  local reg = vim.fn.getreg('"')
  vim.api.nvim_feedkeys('`' .. ma .. 'v`' .. mb .. 'y', 'n', false)
  local start, finish = vim.api.nvim_buf_get_mark(0, ma), vim.api.nvim_buf_get_mark(0, mb)
  _G.__remote_op_opfunc = function()
    _helper(vim.api.nvim_buf_get_mark(0, '['), vim.api.nvim_buf_get_mark(0, ']'))
  end
  vim.go.operatorfunc = 'v:lua.__remote_op_opfunc'
  vim.api.nvim_feedkeys('g@', 'n', false)
  require('flash').remote(vim.tbl_deep_extend('force', {
    remote = {
      on_restore = vim.schedule_wrap(function()
        _helper(start, finish)
        vim.fn.setreg('"', reg)
      end),
    },
  }, opts))
end

local swap_with = function(opts)
  local v = vim.api.nvim_get_mode().mode:lower() == 'v'
  if v then
    _swap_with(opts, '<', '>')
  else
    _G.__remote_op_opfunc = function()
      _swap_with(opts, v and '<' or '[', v and '>' or ']')
    end
    vim.go.operatorfunc = 'v:lua.__remote_op_opfunc'
    vim.api.nvim_feedkeys('g@', 'n', false)
  end
end

-- jump full words
local search_words_2char = function()
  local Flash = require('flash')
  local function format_first_match(opts)
    opts = opts or {}
    return {
      { opts.match.label1, opts.hl_group },
      { opts.match.label2, opts.hl_group },
    }
  end

  local function format_second_match(opts)
    opts = opts or {}
    return {
      { opts.match.label2, opts.hl_group },
    }
  end

  Flash.jump({
    search = { mode = 'search' },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format_first_match },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { after = { 0, 2 }, format = format_second_match },
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

-- jump full words
local jump_words = function()
  require('flash').jump({
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

-- force linewise: <operator>V<motion>
local jump_line = function()
  require('flash').jump({
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '^',
  })
end

local jump_start_words = function()
  require('flash').jump({
    search = {
      mode = function(str)
        return '\\<' .. str
      end,
    },
  })
end

-- show diagnostics at target
local jump_diag = function()
  require('flash').jump({
    matcher = function(win)
      ---@param diag Diagnostic
      return vim.tbl_map(function(diag)
        return {
          pos = { diag.lnum + 1, diag.col },
          end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
        }
      end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
    end,
    action = function(match, state)
      vim.api.nvim_win_call(match.win, function()
        vim.api.nvim_win_set_cursor(match.win, match.pos)
        vim.diagnostic.open_float()
      end)
      state:restore()
    end,
  })
end

return {
  jump_line = jump_line,
  swap_with = swap_with,
  search_words_2char = search_words_2char,
  jump_words = jump_words,
  jump_start_words = jump_start_words,
  jump_diag = jump_diag,
}
