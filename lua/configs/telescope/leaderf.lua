local devicons = require("nvim-web-devicons")
local entry_display = require("telescope.pickers.entry_display")

-- TODO: make option for directory being common prefix, cwd .. directory, project .. directory
-- TODO: special highlighting for alternate file assignment, add last time edited

local filter = vim.tbl_filter
local map = vim.tbl_map

local common_prefix = function(strings)
  if #strings == 0 then
    return ""
  end

  local prefix = strings[1]

  for i = 1, #strings do
    while strings[i]:find(prefix, 1, true) ~= 1 do
      prefix = prefix:sub(1, #prefix - 1)
    end
  end

  -- trim everything after final forward slash
  prefix = prefix:gsub("/[^%/]*$", "")
  return prefix
end

local function gen_from_buffer(opts)
  opts = opts or {}
  local default_icons, _ = devicons.get_icon("file", "", { default = true })

  local bufnrs = filter(function(b)
    return 1 == vim.fn.buflisted(b)
  end, vim.api.nvim_list_bufs())

  local max_bufnr = math.max(unpack(bufnrs))
  local bufnr_width = #tostring(max_bufnr)
  local bufnames = map(function(bufnr)
    return vim.fn.strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t"))
  end, bufnrs)

  local max_bufname = math.max(unpack(bufnames))
  local dirs = map(function(bufnr)
    local dir_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h") .. "/"
    return dir_name:gsub(os.getenv("HOME"), "~")
  end, bufnrs)

  local common_dir_prefix = common_prefix(dirs)
  if common_dir_prefix == "~" then
    common_dir_prefix = ""
  end

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = bufnr_width },
      { width = 4 },
      { width = vim.fn.strwidth(default_icons) },
      { width = max_bufname },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local dir_name = entry.dir_name

    return displayer({
      { entry.bufnr, "TelescopeResultsNumber" },
      { entry.indicator, "TelescopeResultsComment" },
      { entry.devicons, entry.devicons_highlight },
      { entry.file_name, entry.file_name_highlight },
      { entry.dir_name, "Comment" },
    })
  end

  return function(entry)
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local modified = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. modified

    local dir_name = vim.fn.fnamemodify(bufname, ":p:h")
    dir_name = string.gsub(dir_name, os.getenv("HOME"), "~")
    if common_dir_prefix ~= "" then
      dir_name = string.sub(dir_name, #common_dir_prefix + 1)
      dir_name = #dir_name == 0 and "./" or ("." .. dir_name)
    end
    local file_name = vim.fn.fnamemodify(bufname, ":p:t")

    local icons, highlight =
      devicons.get_icon(bufname, string.match(bufname, "%a+$"), { default = true })

    local file_name_highlight = entry.info.changed == 1 and "BufferInactiveMod" or "TelescopeNormal"

    return {
      valid = true,

      value = bufname,
      ordinal = entry.bufnr .. dir_name .. file_name .. dir_name,
      display = make_display,

      bufnr = entry.bufnr,

      lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
      indicator = indicator,
      devicons = icons,
      devicons_highlight = highlight,

      file_name = file_name,
      file_name_highlight = file_name_highlight,
      dir_name = dir_name,
    }
  end
end

local function get_buffers(opts)
  opts = opts or {}
  local bufnrs = filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(b) then
      return false
    end
    if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
      return false
    end
    if opts.cwd_only and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
      return false
    end
    if
      not opts.cwd_only
      and opts.cwd
      and not string.find(vim.api.nvim_buf_get_name(b), opts.cwd, 1, true)
    then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then
    return
  end
  if opts.sort_mru then
    table.sort(bufnrs, function(a, b)
      return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)
  end

  local buffers = {}
  local default_selection_idx = 1
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

    if opts.sort_lastused and not opts.ignore_current_buffer and flag == "#" then
      default_selection_idx = 2
    end

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1],
    }

    if opts.sort_lastused and (flag == "#" or flag == "%") then
      local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
      table.insert(buffers, idx, element)
    else
      table.insert(buffers, element)
    end
  end
  return {
    buffers = buffers,
    default_selection_idx = default_selection_idx,
  }
end
return {
  gen_from_buffer = gen_from_buffer,
  get_buffers = get_buffers,
}
