local config = require('neoai.config')
local curl = require('plenary.curl')

---@type ModelModule
local M = {}
M.name = 'OpenAI'

local handler
local chunks = {}
local raw_chunks = {}

---@brief Cancel the current stream and shut down the handler
M.cancel_stream = function()
  if handler ~= nil then
    handler:shutdown()
    handler = nil
  end
end

M.get_current_output = function()
  return table.concat(chunks, '')
end

---@param chunk string
---@param on_stdout_chunk fun(chunk: string) Function to call whenever a stdout chunk occurs
M._receive_chunk = function(chunk, on_stdout_chunk)
  local function safely_extract_delta_content(decoded_json)
    local path = decoded_json.choices
    if not path then
      return nil
    end

    path = path[1]
    if not path then
      return nil
    end

    path = path.delta
    if not path then
      return nil
    end

    return path.content
  end
  -- Remove "data:" prefix from chunk
  local raw_json = string.gsub(chunk, '%s*data:%s*', '')
  table.insert(raw_chunks, raw_json)

  local ok, decoded_json = pcall(vim.json.decode, raw_json)
  if not ok then
    return -- Ignore invalid JSON chunks
  end

  local delta_content = safely_extract_delta_content(decoded_json)
  if delta_content then
    table.insert(chunks, delta_content)
    on_stdout_chunk(delta_content)
  end
end

---@param chat_history ChatHistory
---@param on_stdout_chunk fun(chunk: string) Function to call whenever a stdout chunk occurs
---@param on_complete fun(err?: string, output?: string) Function to call when model has finished
M.send_to_model = function(chat_history, on_stdout_chunk, on_complete)
  local api_key = os.getenv(config.options.open_api_key_env)

  local data = {
    model = chat_history.model,
    stream = true,
    messages = chat_history.messages,
  }
  data = vim.tbl_deep_extend('force', {}, data, chat_history.params)
  vim.dbglog(config.options.open_api_url, data)

  chunks = {}
  raw_chunks = {}
  handler = curl.post({
    url = config.options.open_api_url,
    raw = { '--no-buffer' },
    headers = {
      content_type = 'application/json',
      Authorization = 'Bearer ' .. api_key,
    },
    body = vim.json.encode(data),
    stream = function(_, chunk)
      if chunk ~= '' then
        -- The following workaround helps to identify when the model has completed its task.
        if string.match(chunk, '%[DONE%]') then
          vim.schedule(function()
            on_complete(nil, M.get_current_output())
          end)
        else
          vim.schedule(function()
            M._receive_chunk(chunk, on_stdout_chunk)
          end)
        end
      end
    end,
    on_error = function(err, _, _)
      return on_complete(err, nil)
    end,
  })
end

-- curl https://api.openai.com/v1/chat/completions \
--   -H "Content-Type: application/json" \
--   -H "Authorization: Bearer $OPENAI_API_KEY" \
--   -d '{
--   "model": "gpt-4",
--   "messages": [
--     {
--       "role": "system",
--       "content": "You will be provided with text delimited by triple quotes that is supposed to be the answer to a question. Check if the following pieces of information are directly contained in the answer: \n\n- Neil Armstrong was the first person to walk on the moon.\n- The date Neil Armstrong first walked on the moon was July 21, 1969.\n\nFor each of these points perform the following steps:\n\n1 - Restate the point.\n2 - Provide a citation from the answer which is closest to this point.\n3 - Consider if someone reading the citation who doesn'\''t know the topic could directly infer the point. Explain why or why not before making up your mind.\n4 - Write \"yes\" if the answer to 3 was yes, otherwise write \"no\".\n\nFinally, provide a count of how many \"yes\" answers there are. Provide this count as {\"count\": insert-count-here}."
--     },
--     {
--       "role": "user",
--       "content": "\"\"\"Neil Armstrong is famous for being the first human to set foot on the Moon. This historic event took place on July 21, 1969, during the Apollo 11 mission.\"\"\""
--     },
--     {
--       "role": "assistant",
--       "content": "1 - Neil Armstrong was the first person to walk on the moon.\n2 - \"Neil Armstrong is famous for being the first human to set foot on the Moon.\"\n3 - Yes, someone reading the citation could directly infer that Neil Armstrong was the first person to walk on the moon because it explicitly states that he was the first human to set foot on the Moon.\n4 - Yes\n\n1 - The date Neil Armstrong first walked on the moon was July 21, 1969.\n2 - \"This historic event took place on July 21, 1969, during the Apollo 11 mission.\"\n3 - Yes, someone reading the citation could directly infer that Neil Armstrong first walked on the moon on July 21, 1969 because it explicitly states the date of the event.\n4 - Yes\n\n{\"count\": 2}"
--     }
--   ],
--   "temperature": 0,
--   "max_tokens": 1024,
--   "top_p": 1,
--   "frequency_penalty": 0,
--   "presence_penalty": 0
-- }'

return M
