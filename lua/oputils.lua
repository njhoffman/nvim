local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)

local get_range_pos = function()
  return { vim.fn.getpos("."), vim.fn.getpos("v") }
end

local is_visual = function()
  return vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "CTRL-V"
end

local state = { init = {}, movements = {} }

local get_object_range = function(object)
  -- Save current cursor position and selection.
  -- Determine positions of textobject edges.
  vim.cmd("normal v" .. object)
  vim.api.nvim_feedkeys(esc, "x", false)
  -- :h line(), you can use :h getpos() with v and .
  local object_start = vim.fn.getpos(".")
  local object_end = vim.fn.getpos("v")
  -- Restore original position.
  if init_start and init_end then
    if init_start[2] == init_cursor[2] and init_start[3] == init_cursor[3] then
      vim.fn.setpos(".", init_end)
      vim.cmd("normal! v")
      vim.fn.setpos(".", init_start)
    else
      vim.fn.setpos(".", init_start)
      vim.cmd("normal! v")
      vim.fn.setpos(".", init_end)
    end
  else
    vim.fn.setpos(".", init_cursor)
  end
  -- Jump to textobject start/end.
  if init_cursor[2] == object_start[2] and init_cursor[3] == object_start[3] then
    vim.fn.setpos(".", object_end)
  else
    vim.fn.setpos(".", object_start)
  end
end
local function word_start_end()
  object_start_end("iw")
end

local get_motion_positions = function(motions)
  state.init = { mode = vim.fn.get_mode(true), pos = get_range_pos() }
  for _, motion in ipairs(motions) do
    local object_start = vim.fn.getpos(".")
    local object_end = vim.fn.getpos("v")
    if motion == "iw" then
      if is_visual() then
        vim.api.nvim_feedkeys(esc, "x", false)
        init_start = vim.fn.getpos(".")
        init_end = vim.fn.getpos("v")
      end
      vim.cmd("normal! v" .. motion)
      vim.api.nvim_feedkeys(esc, "x", false)
      if init_start and init_end then
        if init_start[2] == init_cursor[2] and init_start[3] == init_cursor[3] then
          vim.fn.setpos(".", init_end)
          vim.cmd("normal! v")
          vim.fn.setpos(".", init_start)
        else
          vim.fn.setpos(".", init_start)
          vim.cmd("normal! v")
          vim.fn.setpos(".", init_end)
        end
      else
        vim.fn.setpos(".", init_cursor)
      end
    end
  end
end

local text_objects = { "aG", "aI", "ai", "ak", "av", "a_", "am", "az", "a%", "au" }
local builtin_textobjects = {
  "aw",
  "iw",
  "aW",
  "iW",
  "as",
  "is",
  "ap",
  "ip",
  "a]",
  "a[",
  "i]",
  "i[",
  "a)",
  "a(",
  "ab",
  "i)",
  "i(",
  "ib",
  "a>",
  "a<",
  "i>",
  "i<",
  "at",
  "it",
  "a}",
  "a{",
  "aB",
  "i}",
  "i{ ",
  "iB",
  'a"',
  "a'",
  "a`",
}
