local sqlite = require('sqlite.db') --- for constructing sql databases
local tbl = require('sqlite.tbl') --- for constructing sql tables
local mock_data = require('neoai.sql.mock_data')

local config = {
  uri = vim.fn.stdpath('data') .. '/neoai.sqlite',
}

local strftime = sqlite.lib.strftime

local seed_db = function(entries)
  for _, row in ipairs(mock_data) do
    local id = entries:insert(row)
    vim.dbglog('ID', id)
  end
end

local reset_db = function(entries)
  assert(entries:remove())
end

local init_db = function()
  ---@type BMEntryTable
  local entries = tbl('entries', {
    id = true, -- same as { type = "integer", required = true, primary = true }
    prompt_content = 'text',
    prompt_role = 'text',
    response_content = 'text',
    response_role = 'text',
    model = 'text',
    project = 'text',
    ts = { 'date', default = strftime('%s', 'now') },
  })

  ---@type BMEntryTable
  local sessions = tbl('sessions', {
    id = true, -- same as { type = "integer", required = true, primary = true }
    entries = {
      type = 'integer',
      reference = 'entries.id',
      on_delete = 'cascade', --- when referenced entry is deleted, delete self
    },
    model = 'text',
    project = 'text',
    ts = { 'date', default = strftime('%s', 'now') },
  })

  local BM = sqlite({
    uri = config.uri,
    entries = entries,
    sessions = sessions,
    opts = {},
  })

  return entries
end

local entries = init_db()
reset_db(entries)
seed_db(entries)
