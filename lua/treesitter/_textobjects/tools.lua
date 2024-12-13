-- local queries = require('nvim-treesitter.query')
-- local ts_utils = require('nvim-treesitter.ts_utils')
-- local ts = require('nvim-treesitter.compat')
-- local tsobjs = available_textobjects('lua', 'textobjects')
-- local buffer_matches = require('nvim-treesitter.query').get_matches(5, 'textobjects')
-- local shared = require("nvim-treesitter.textobjects.shared")

-- require'nvim-treesitter.configs'.setup { textobjects = { select = { } } )

function has_ts(buf)
  vim.validate({ buf = { buf, "number", true } })
  buf = buf or vim.api.nvim_get_current_buf()
  return ok
end

local parsers = require("nvim-treesitter.parsers")

local lang = parsers.get_buf_lang()
local parsed_queries = vim.treesitter.query.get(lang, "textobjects")
local found_textobjects = parsed_queries.captures or {}
for _, p in pairs(parsed_queries.info.patterns) do
  for _, q in ipairs(p) do
    local query, arg1 = unpack(q)
    if query == "make-range!" and not vim.tbl_contains(found_textobjects, arg1) then
      table.insert(found_textobjects, arg1)
    end
  end
end

-- MiniAi.search_cursors
