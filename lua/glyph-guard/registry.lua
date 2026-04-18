local M = {}

local function normalize(str)
  local hex = str:match("^U%+([0-9A-Fa-f]+)$")
  if not hex then
    return nil
  end
  return tonumber(hex, 16)
end

function M.load(path)
  local expanded = vim.fn.expand(path)
  local ok, lines = pcall(vim.fn.readfile, expanded)
  if not ok then
    return { by_codepoint = {} }
  end

  local ok2, data = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok2 or type(data) ~= "table" then
    return { by_codepoint = {} }
  end

  local map = {}
  for name, entry in pairs(data) do
    if type(entry) == "table" and entry.codepoint then
      local cp = normalize(entry.codepoint)
      if cp then
        map[cp] = name
      end
    end
  end

  return { by_codepoint = map }
end

return M
