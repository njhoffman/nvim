local M = {}
local config = require("debuglog.config")

--   -- Uses treesitter to see if there's a logger
--   local function java_log()
--   local query_text = [[
--   (marker_annotation name: (identifier) @annotation_name (#any-of? @annotation_name "Slf4j" "Log" "Log4j" "Logger"))
--   ]]
-- local lang = require('nvim-treesitter.parsers').ft_to_lang('java')
-- local query = vim.treesitter.query.parse(lang, query_text)
-- print(vim.inspect(query))
--
-- for _ in query:iter_captures(vim.treesitter.get_parser():parse()[1]:root(), 0) do
--   return 'log.debug("%s: {}", %s);'
-- end
--
-- return 'System.out.println("%s: " + %s);'
-- end
--
--
-- function DebugPrint(above)
--   -- TODO: Use treesitter
--   local word = vim.fn.expand('<cword>')
--   local ft = vim.bo.ft:lower()
--
--   local statent_template
--
--   if ft == 'java' then
--     statent_template = java_log()
--   elseif ft == 'lua' then
--     statent_template = 'print("%s: ", %s)'
--   elseif ft == 'typescript' or ft == 'javascript' then
--     statent_template = 'console.log("%s: ", %s)'
--   end
--
--   if statent_template then
--     local statent = string.format(statent_template, word, word)
--
--     local cursor = vim.api.nvim_win_get_cursor(0)
--     local row, _ = unpack(cursor)
--
--     if above then
--       row = row - 1
--     end
--
--     vim.api.nvim_buf_set_lines(0, row, row, false, { statent })
--   end
-- end
--
-- vim.keymap.set('n', '<leader>dp', function()
--   DebugPrint(false)
-- end)
--
-- vim.keymap.set('n', '<leader>dP', function()
--   DebugPrint(true)
-- end)
--
local round = function(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
end

M.make_string = function(...)
  local t = {}
  for i = 1, select("#", ...) do
    local x = select(i, ...)

    if type(x) == "number" and config.float_precision then
      x = tostring(round(x, config.float_precision))
    elseif type(x) == "table" then
      x = type(vim.dump) == "function" and vim.dump(x) or vim.inspect(x)
    else
      x = tostring(x)
    end

    t[#t + 1] = x
  end
  return table.concat(t, " ")
end

M.wrap = function(str, limit, indent, indent1)
  if type(str) ~= "string" then
    return str
  end
  indent = indent or ""
  indent1 = indent1 or indent
  limit = limit or 30
  local here = 1 - #indent1
  return indent1
    .. str:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
      if fi - here > limit then
        here = st - #indent
        return "\n" .. indent .. word
      end
    end)
end

M.log_level_number = function(name)
  name = name or "info"
  local levels = { "trace", "debug", "info", "warn", "error" }
  local level_n = 1
  for i, level in ipairs(levels) do
    if level == name then
      level_n = i
    end
  end
  return level_n
end

M.log_level_name = function(num)
  local levels = { "trace", "debug", "info", "warn", "error" }
  local level_name = ""
  for i, level in ipairs(levels) do
    if i == num + 1 then
      level_name = level
    end
  end
  return level_name
end

return M
