local previewers = require('telescope.previewers')

local normalize_html = function(str)
  local symbol_map = {
    ['&lt;'] = '<',
    ['&gt;'] = '>',
    ['&amp;'] = '&',
    ['&quot;'] = '"',
    ['&apos;'] = "'",
    ['&nbsp;'] = ' ',
    ['&copy;'] = '©',
    ['&ndash;'] = '–',
  }

  for key, value in pairs(symbol_map) do
    str = str:gsub(key, value)
  end

  return str
end

-- local to_yaml = function(entry)
--   local lines = {}
--
--   for key, value in pairs(entry) do
--     if key == 'attribution' then
--       value = normalize_html(value)
--       value = value:gsub('<a.*>(.*)</a>', '%1')
--       value = value:gsub('<br>', '')
--       value = value:gsub('\n *', ' ')
--     end
--     if key == 'links' then
--       value = vim.fn.json_encode(value)
--     end
--     table.insert(lines, key .. ': ' .. value)
--   end
--
--   return table.concat(lines, '\n')
-- end
local to_yaml = function(entry)
  local lines = {}

  for key, value in pairs(entry) do
    value = tostring(value)

    if key == 'attribution' then
      value = normalize_html(value)
      value = value:gsub('<a.*>(.*)</a>', '%1')
      value = value:gsub('<br>', '')
      value = value:gsub('\n *', ' ')
    end
    if key == 'links' then
      value = vim.fn.json_encode(value)
    end
    table.insert(lines, key .. ': ' .. value)
  end
  return table.concat(lines, '\n')
end
-- abbr = 0, buffer = 0, desc = "remove highlights and refresh", expr = 0,
-- lhs = "<Esc>", lhsraw = "\27",
-- lnum = 0, mode = "n", mode_bits = 1, noremap = 1, nowait = 0,
-- rhs = "<Cmd>noh<CR> | <Cmd>lua require(\"flash.util\").exit()<CR>",
-- script = 0, scriptversion = 1, sid = -8, silent = 0
-- mode, lhs, rhs, desc, buffer, expr, silent, abbr, noremap, nowait, mode_bits,
-- lnum, lhsraw, script, scriptversion, sid,
local keymaps_previewer = previewers.new_buffer_previewer({
  title = 'Keymaps',
  define_preview = function(self, entry)
    local bufnr = self.state.bufnr
    local transpiled = to_yaml(entry.value)
    local lines = vim.split(transpiled, '\n')
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].ft = 'yaml'
  end,
})

return keymaps_previewer
