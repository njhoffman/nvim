local function process(result)
  local ok, res = pcall(vim.json.decode, result)
  if not ok or not res[1] then
    -- async.scheduler()
    -- vim.notify("Failed to parse dictionary response", vim.log.levels.ERROR)
    return
  end

  local json = res[1]

  local lines = {
    json.word,
  }

  for _, def in ipairs(json.meanings[1].definitions) do
    lines[#lines + 1] = ""
    lines[#lines + 1] = def.definition
    if def.example then
      lines[#lines + 1] = "Example: " .. def.example
    end
  end

  return lines
end

local word = "echo"
local output = vim.fn.system("curl -s" .. " " .. "https://api.dictionaryapi.dev/api/v2/entries/en/" .. word)
local results = process(output)
vim.dbglog(results)
