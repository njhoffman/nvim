-- trim './' prefix
local function trim_prefix(file_path)
  if string.sub(file_path, 1, 2) == "./" then
    return string.sub(file_path, 3)
  end
  return file_path
end

local function split(s, delimiter)
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

local function file_exists(name)
  local cursor = io.open(name, "r")
  if cursor == nil then
    return false
  end
  io.close(cursor)
  return true
end

function ListFilesUnderCursor(opt)
  if opt == nil then
    opt = {}
  end
  local file = vim.fn.expand("<cfile>")
  if #file == 0 then
    vim.notify("no file under cursor")
    return
  end

  local line = vim.api.nvim_get_current_line()
  local _, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  local char_in_filename = {}
  for i = 1, #file do
    char_in_filename[file:sub(i, i)] = true
  end

  local end_file_position = cursor_col
  for i = cursor_col, #line do
    end_file_position = i
    if not char_in_filename[line:sub(i, i)] then
      break
    end
  end

  line = line:sub(end_file_position)

  local row, col
  -- try to extract row and col

  -- pattern main.c:row:col
  local _row, _col = string.match(line, "^:(%d+):(%d+)")
  if _row and _col then
    row = tonumber(_row)
    col = tonumber(_col)
  end

  -- pattern main.c:row
  if not row then
    _row = string.match(line, "^:(%d+)")
    if _row then
      row = tonumber(_row)
      col = tonumber(_col)
    end
  end

  -- pattern (quickfix) main.c|111 col 222|
  if not row then
    _row, _col = string.match(line, "|(%d+) col (%d+)|")
    if _row and _col then
      row = tonumber(_row)
      col = tonumber(_col)
    end
  end

  local options = {}
  local file_map = {}

  if string.sub(file, 1, 1) == "/" then
    file = file.sub(file, 2)
  end

  if file_exists(file) then
    file_map[file] = true
    table.insert(options, { path = file, lnum = row, col = col })
  end

  -- if #vim.o.path == 0 then
  -- 	vim.notify("no path defined")
  -- 	return
  -- end

  local folders = split(vim.o.path, ",")
  for _, folder in ipairs(folders) do
    if #folder > 0 then
      if string.sub(folder, -1) ~= "/" then
        folder = folder .. "/"
      end
      local fullpath = trim_prefix(vim.fn.simplify(folder .. file))
      if file_map[fullpath] then
        goto continue
      end
      if file_exists(fullpath) then
        table.insert(options, { path = fullpath, lnum = row, col = col })
        file_map[fullpath] = true
      end
    end
    ::continue::
  end

  if #options == 0 then
    vim.notify("no file found in current paths: " .. vim.o.path)
    return
  end

  opt = vim.tbl_extend("force", local_opt.telescope, opt)

  if _row then
    if _col then
      opt.prompt_title = opt.prompt_title .. " (line " .. _row .. ", col " .. _col .. ") "
    else
      opt.prompt_title = opt.prompt_title .. " (line " .. _row .. ") "
    end
  end

  select_files(options, opt)
end

local get_files = function()
  local files = {}
  table.insert(files, {
    path = "~/.config/nvim/init.lua",
    lnum = 10,
    col  = 5,
  })
  table.insert(files, {
    path = "~/.config/nvim/lua/plugins/load.lua",
    lnum = 20,
    col  = 1,
  })
  table.insert(files, {
    path = "~/.config/nvim/lua/vim-options.lua",
    lnum = 3,
    col  = 1,
  })
  return files
end

return { get_files = get_files }
