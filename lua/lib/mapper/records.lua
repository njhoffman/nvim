---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
local start_time = vim.fn.reltime()

local crc = require('lib.mapper.crc')

local records = { list = {}, tree = {}, clues = {} }

local idx = 0
local function add(virtual, mode, lhs, rhs, opts, meta)
  local unique_id = crc.get_crc(lhs .. '_' .. mode)
  idx = idx + 1
  opts = opts or {}
  meta = meta or {}
  meta.time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  meta.virtual = virtual
  local debuginfo = debug.getinfo(3, 'S')
  meta.source = debuginfo.source:sub(2) .. ':' .. debuginfo.linedefined

  local record = {
    mode = mode,
    lhs = lhs,
    rhs = rhs,
    meta = meta,
    opts = opts,
    unique_id = unique_id,
    idx = idx,
  }

  if virtual == true then
    if rhs ~= nil then
      vim.notify('Virtual mapping has rhs: ' .. record.mode .. ' ' .. record.lhs .. '\n' .. vim.inspect(record), 3)
    end
    table.insert(records.clues, { mode = record.mode, keys = record.lhs, desc = opts.desc })
  end

  if vim.tbl_contains(records.list, unique_id) then
    local existing = records.list[unique_id]
    record.history = vim.fn.deepcopy(existing.history or {})
    table.insert(record.history, vim.fn.deepcopy(existing))
  end

  records.list[unique_id] = record
  records.tree[mode] = records.tree[mode] or {}
  records.tree[mode][lhs] = rhs
end

return {
  tree = records.tree,
  list = records.list,
  clues = records.clues,
  add = add,
}
