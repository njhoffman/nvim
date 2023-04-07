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

local dict_handler = function(start_time)
  local word = vim.fn.expand("<cword>")
  if string.len(word) == 0 then
    return { summary = "  -------- dict  ", hl = "DebugMsg" }
  end

  local output = vim.fn.system("curl -s" .. " " .. "https://api.dictionaryapi.dev/api/v2/entries/en/" .. word)
  local results = process(output)

  if not results then
    return { summary = "  -------- dict  ", hl = "DebugMsg" }
  else
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    return { summary = load_time .. " dict  " .. word .. " " .. #results .. " lines", hl = "MoreMsg" }
  end
end
return { handler = dict_handler }

-- {
--   "title": "No Definitions Found",
--   "message": "Sorry pal, we couldn't find definitions for the word you were looking for.",
--   "resolution": "You can try the search again at later time or head to the web instead."
-- }
--
-- [
--   {
--     "word": "echo",
--     "phonetic": "/ˈɛkəʊ/",
--     "phonetics": [
--       {
--         "text": "/ˈɛkəʊ/",
--         "audio": ""
--       },
--       {
--         "text": "/ˈɛkoʊ/",
--         "audio": "https://api.dictionaryapi.dev/media/pronunciations/en/echo-us.mp3",
--         "sourceUrl": "https://commons.wikimedia.org/w/index.php?curid=1762922",
--         "license": {
--           "name": "BY-SA 3.0",
--           "url": "https://creativecommons.org/licenses/by-sa/3.0"
--         }
--       }
--     ],
--     "meanings": [
--       {
--         "partOfSpeech": "noun",
--         "definitions": [
--           {
--             "definition": "A reflected sound that is heard again by its initial observer.",
--             "synonyms": [],
--             "antonyms": []
--           },
--         ],
--         "synonyms": [],
--         "antonyms": []
--       },
--     }
--   }
-- ]
