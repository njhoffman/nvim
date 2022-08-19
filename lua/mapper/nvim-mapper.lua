-- nvim-mapper
local M = {}
M.mapper_records = {}

-- Set a mapping
local function map(virtual, bufnr, mode, keys, cmd, options, category, id, description)
  local buffer_only = false
  if bufnr ~= nil then buffer_only = true end

  local unique_id = id .. '_' .. mode
  local record = {
    mode = mode,
    keys = keys,
    cmd = cmd,
    options = options,
    category = category,
    unique_identifier = unique_id,
    description = description,
    buffer_only = buffer_only,
    n = 1
  }
  local existing_record = M.mapper_records[unique_id]
  if existing_record then
    record.n = existing_record.n + 1
    unique_id = unique_id .. '_' .. record.n
  end
  M.mapper_records[unique_id] = record

  if not virtual then
    if bufnr ~= nil then
      vim.api.nvim_buf_set_keymap(bufnr, mode, keys, cmd, options)
    else
      vim.api.nvim_set_keymap(mode, keys, cmd, options)
    end
  end
end

-- Set a buffer mapping
function M.map_buf(bufnr, mode, keys, cmd, options, category, id, description)
  map(false, bufnr, mode, keys, cmd, options, category, id, description)
end

-- Set a global mapping
function M.map(mode, keys, cmd, options, category, id, description)
  map(false, nil, mode, keys, cmd, options, category, id, description)
end

-- Set a virtual buffer mapping
function M.map_buf_virtual(bufnr, mode, keys, cmd, options, category, id, description)
  map(true, bufnr, mode, keys, cmd, options, category, id, description)
end

-- Set a virtual global mapping
function M.map_virtual(mode, keys, cmd, options, category, id, description)
  map(true, nil, mode, keys, cmd, options, category, id, description)
end

function M.setup(opts)
  opts = opts or {}

  -- Search path
  if opts.search_path ~= nil then
    vim.g.mapper_search_path = opts.search_path
  else
    vim.g.mapper_search_path = vim.fn.stdpath('config') .. "/lua"
  end

  -- Selected action
  if opts.action_on_enter ~= nil then
    vim.g.mapper_action_on_enter = opts.action_on_enter
  else
    vim.g.mapper_action_on_enter = "definition"
  end
end

M.setup()

return M
