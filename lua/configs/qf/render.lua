local fn = vim.fn
local signMap = {
  E = ' ',
  W = ' ',
  I = ' ',
  H = ' ',
  N = ' ',
}

-- :vimgrep /\w\+/j % | copen
local format_filename = function(filename, limit, right_align)
  local fnameFmt1 = (right_align and '%' or '%-') .. (limit == nil and '' or limit) .. 's'
  local fnameFmt2 = '…%.' .. (type(limit) ~= 'number' and '' or limit - 1) .. 's'
  local cwd = fn.getcwd()
  if filename:sub(1, #cwd) == cwd then
    filename = filename:sub(#cwd + 2)
  end
  if filename == '' then
    filename = '[No Name]'
  else
    filename = filename:gsub('^' .. vim.env.HOME, '~')
  end
  -- char in filename may occur more than 1 width, ignore this issue in order to keep performance
  if limit == nil or #filename <= limit then
    filename = fnameFmt1:format(filename)
  else
    filename = fnameFmt2:format(limit == nil and filename or filename:sub(1 - limit))
  end
  return filename
end

local get_max_widths = function(id)
  id = id or 0
  local w = { fname = 0, line = 0, col = 0 }
  local qf = fn.getqflist({ id = id, items = 0 })
  for _, v in ipairs(qf.items) do
    -- bufnr, col, end_col, end_lumn, lnum, module, nr, pattern, text, type, validid, vcol
    local fname = ''
    if v.valid == 1 then
      if v.bufnr > 0 then
        fname = format_filename(fn.bufname(v.bufnr))
        w.fname = math.max(w.fname, #fname)
        w.line = math.max(w.line, #(tostring(v.lnum)))
        w.col = math.max(w.col, #(tostring(v.col)))
      end
    end
  end
  return w
end

local config = {
  qf_width_limit = 40,
  fname_align = 'right',
}

-- info.quickfix	set to 1 when called for a quickfix list and 0 when called for a location list.
-- info.winid	for a location list, set to the id of the window with the location list. For a quickfix list, set to 0. Can be used in getloclist() to get the location list entry.
-- info.id		quickfix or location list identifier
-- info.start_idx	index of the first entry for which text should be returned
-- info.end_idx	index of the last entry for which text should be returned
_G.qftf = function(info)
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local widths = get_max_widths(info.id)
  widths.fname = widths.fname > config.qf_width_limit and config.qf_width_limit or widths.fname

  -- local validFmt = '%s │%5d:%-3d│%s %s'
  local validFmt = '%s │%' .. (widths.line + 1) .. 'd:%-' .. (widths.col + 1) .. 'd│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = format_filename(fn.bufname(e.bufnr), widths.fname, config.fname_align == 'right')
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. signMap[e.type:sub(1, 1):upper()]
      -- local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
