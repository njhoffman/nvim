---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
local start_time = vim.fn.reltime()

local crc = require("mapper.crc")

local records = { list = {}, tree = {} }

local idx = 0
local function add_record(virtual, mode, lhs, rhs, options)
  local buffer_only = false
  if options.buffer ~= nil then
    buffer_only = true
  end

  local unique_id = crc.get_crc(lhs .. "_" .. mode)
  idx = idx + 1

  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  local time = vim.fn.reltimestr(vim.fn.reltime(start_time))

  local keymap_opts = {
    remap = options.remap or (options.noremap == false),
    silent = options.silent,
  }

  local record = {
    mode = mode,
    lhs = lhs,
    rhs = rhs,
    options = keymap_opts,
    category = options.category,
    plugin = options.plugin,
    unique_identifier = unique_id,
    description = options.description,
    label = options.label,
    virtual = virtual,
    time = time,
    idx = idx,
    buffer_only = buffer_only,
  }
  if vim.tbl_contains(records.list, unique_id) then
    local existing = records.list[unique_id]
    record.n = existing.n + 1
    record.history = vim.fn.deepcopy(existing.history)
    table.insert(record.history, vim.fn.deepcopy(existing))
  else
    record.n = 0
    record.history = {}
  end
  records.list[unique_id] = record
  records.tree[mode] = records.tree[mode] or {}
  records.tree[mode][lhs] = unique_id
end

return {
  tree = records.tree,
  list = records.list,
  add = add_record,
}
