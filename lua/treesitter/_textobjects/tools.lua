
function has_ts(buf)
  vim.validate({ buf = { buf, 'number', true } })
  buf = buf or vim.api.nvim_get_current_buf()
  return ok
end

local shared = require('nvim-treesitter.textobjects.shared')
  -- require'nvim-treesitter.configs'.setup { textobjects = { select = { } } )
local parsed_queries = vim.treesitter.query.get('lua', 'textobjects')
local found_textobjects = parsed_queries.captures or {}
for _, p in pairs(parsed_queries.info.patterns) do
  for _, q in ipairs(p) do
    local query, arg1 = unpack(q)
    if query == 'make-range!' and not vim.tbl_contains(found_textobjects, arg1) then
      table.insert(found_textobjects, arg1)
    end
  end
end
local function available_textobjects(lang, query_group)
  lang = lang or parsers.get_buf_lang()
  query_group = query_group or 'textobjects'
  local parsed_queries = vim.treesitter.query.get(lang, query_group)
  if not parsed_queries then
    return {}
  end
  local found_textobjects = parsed_queries.captures or {}
  for _, p in pairs(parsed_queries.info.patterns) do
    for _, q in ipairs(p) do
      local query, arg1 = unpack(q)
      if query == 'make-range!' and not vim.tbl_contains(found_textobjects, arg1) then
        table.insert(found_textobjects, arg1)
      end
    end
  end
  return found_textobjects
end

local parsers = require('nvim-treesitter.parsers')
local queries = require('nvim-treesitter.query')
local ts_utils = require('nvim-treesitter.ts_utils')
local ts = require('nvim-treesitter.compat')
local tsobjs = available_textobjects('lua', 'textobjects')
local buffer_matches = require('nvim-treesitter.query').get_matches(5, 'textobjects')

-- MiniAi.search_cursors
