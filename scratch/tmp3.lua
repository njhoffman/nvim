local fn = vim.fn

-- :vimgrep /\w\+/j % | copen
local format_filename = function(filename, limit)
  local fnameFmt1 = '%-' .. (limit == nil and '' or limit) .. 's'
  local fnameFmt2 = '…%.' .. (limit == nil and '' or limit - 1) .. 's'
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

local get_max_filename_width = function(id)
  id = id or 0
  local width = 0
  local qf = fn.getqflist({ id = id, items = 0 })
  for _, v in ipairs(qf.items) do
    local fname = ''
    local str
    if v.valid == 1 then
      if v.bufnr > 0 then
        fname = format_filename(fn.bufname(v.bufnr))
        width = math.max(width, #fname)
      end
    end
  end
  return width
end

local config = {
  qf_width_limit = 40,
}

function _G.qftf(info)
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local limit = get_max_filename_width(info.id)
  limit = limit > config.qf_width_limit and config.qf_width_limit or limit

  local validFmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = format_filename(fn.bufname(e.bufnr), limit)
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
