local has_devicons, devicons = pcall(require, "nvim-web-devicons")
local entry_display = require("telescope.pickers.entry_display")
local state = require("telescope._extensions.frecency.state")
local utils = require("telescope.utils")
local os_home = vim.loop.os_homedir()
local Path = require("plenary.path")

local function filepath_formatter(_path_opts)
  local path_opts = {}
  for k, v in pairs(_path_opts) do
    path_opts[k] = v
  end

  return function(filename)
    path_opts.cwd = state.active_filter or state.cwd
    return utils.transform_path(path_opts, filename)
  end
end

local function should_show_tail()
  local filters = type(state.show_filter_column) == "table" and state.show_filter_column or { "LSP", "CWD" }
  return vim.tbl_contains(filters, state.active_filter_tag)
end

local function get_display_cols()
  local directory_col_width = 0
  if state.active_filter then
    if should_show_tail() then
      -- TODO: Only add +1 if opts.show_filter_thing is true, +1 is for the trailing slash
      directory_col_width = #(utils.path_tail(state.active_filter)) + 1
    else
      directory_col_width = #(Path:new(state.active_filter):make_relative(os_home)) + 1
    end
  end
  local res = {}
  res[1] = state.show_scores and { width = 8 } or nil
  if has_devicons and not state.disable_devicons then
    table.insert(res, { width = 2 }) -- icon column
  end
  if state.show_filter_column then
    table.insert(res, { width = directory_col_width })
  end
  table.insert(res, { remaining = true })
  return res
end

local os_path_sep = utils.get_separator()

local bufnr, buf_is_loaded, display_filename, hl_filename, display_items, icon, icon_highlight

local init = function(opts)
  local formatter = filepath_formatter(opts)

  local displayer = entry_display.create({
    separator = "",
    hl_chars = { [os_path_sep] = "TelescopePathSeparator" },
    items = get_display_cols(),
  })

  local function make_display(entry)
    bufnr = vim.fn.bufnr
    buf_is_loaded = vim.api.nvim_buf_is_loaded
    display_filename = entry.name
    hl_filename = buf_is_loaded(bufnr(display_filename)) and "TelescopeBufferLoaded" or ""
    display_filename = formatter(display_filename)

    display_items = state.show_scores and { { entry.score, "TelescopeFrecencyScores" } } or {}

    if has_devicons and not state.disable_devicons then
      icon, icon_highlight = devicons.get_icon(entry.name, string.match(entry.name, "%a+$"), { default = true })
      table.insert(display_items, { icon, icon_highlight })
    end

    -- TODO: store the column lengths here, rather than recalculating in get_display_cols()
    if state.show_filter_column then
      local filter_path = ""
      if state.active_filter then
        if should_show_tail() then
          filter_path = utils.path_tail(state.active_filter) .. os_path_sep
        else
          filter_path = Path:new(state.active_filter):make_relative(os_home) .. os_path_sep
        end
      end

      table.insert(display_items, { filter_path, "Directory" })
    end

    table.insert(display_items, { display_filename, hl_filename })

    return displayer(display_items)
  end

  return { make_display = make_display }
end

return { init = init }
