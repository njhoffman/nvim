local sources = require('tracker.sources')
local log = vim.dbglog or print

local test_components = {
  get = false,
  diff = false,
  output = true,
}

-- stylua: ignore
local source_items = {
  { 'aucmds',        {} },
  -- { 'augroups', {} },
  -- { 'aucmds_buffer', {} },
  -- { 'aucmds_global', {} },
  -- { 'keys_global', {} },
  -- { 'keys_buffer', {} },
  -- { 'opts_global', {} },
  -- { 'opts_buffer', {} },
  -- { 'opts_window', {} },
  -- { 'vars_global', {} },
  -- { 'vars_predef', {} },
  -- { 'vars_window', {} },
  -- -- { 'vars_buffer', {} },
  -- { 'highlights',  {} },
  -- { 'code_target', { name = 'code_list', location = 'tracker.test-code_target', target = 'state_list' } },
  -- { 'code_target', { name = 'code_table', location = 'tracker.test-code_target', target = 'state_table' } },
  -- -- vars_script = {},
  -- -- vars_language = {},
  -- -- vars_terminal = {},
}

local get_n_items = function(source, n)
  n = n or 5
  local data, columns = source:get()
  return vim.fn.slice(data, 0, n), columns
end

local display_n_items = function(source, n)
  local data, columns = get_n_items(source, n)
  log('get ' .. source.name .. ': ' .. #data .. '\n', data, columns)
end

local test_get = function(opts)
  for _, source_item in ipairs(source_items) do
    -- for source_name, source_cfg in pairs(source_items) do
    local source_name, source_cfg = source_item[1], source_item[2]
    local source = sources[source_name]:_init(opts, source_cfg)
    display_n_items(source, 1)
  end
end

local get_diff_items = function(source)
  local prev_data, columns = get_n_items(source, 3)
  local prev_items = source:_serialize(prev_data)
  local curr_data = vim.fn.deepcopy(vim.fn.slice(prev_data, 0, 2))
  local curr_items = source:_serialize(curr_data)
  return prev_items, curr_items
end

local test_diff = function(opts)
  for _, source_item in ipairs(source_items) do
    local source_name, source_cfg = source_item[1], source_item[2]
    local source = sources[source_name]:_init(opts, source_cfg)
    local prev_items, curr_items = get_diff_items(source)
    log(
      '\n  prev: '
        .. vim.fn.join(vim.tbl_keys(prev_items), ',')
        .. '\n  curr: '
        .. vim.fn.join(vim.tbl_keys(curr_items), ',')
    )
    local delta_removed = source:_diff(prev_items, curr_items)
    log(delta_removed)
    local delta_added = source:_diff(curr_items, prev_items)
    log(delta_added)
  end
end

local test_output = function(opts)
  for _, source_item in ipairs(source_items) do
    local source_name, source_cfg = source_item[1], source_item[2]
    local source = sources[source_name]:_init(opts, source_cfg)
    local prev_items, curr_items = get_diff_items(source)
    local delta_removed = source:_diff(prev_items, curr_items)
    source:_output_diff(delta_removed)
    local delta_added = source:_diff(curr_items, prev_items)
    source:_output_diff(delta_added)
  end
end

if test_components.get then
  test_get()
end
if test_components.diff then
  test_diff()
end
if test_components.output then
  test_output()
end
