-- https://github.com/james1236/backseat.nvim/issues/15
require('backseat').setup({
  openai_api_key = os.getenv('OPENAI_API_KEY'),
  openai_model_id = 'gpt-3.5-turbo', --gpt-4
  language = 'english', -- Such as 'japanese', 'french', 'pirate', 'LOLCAT'
  -- The max number of lines of code sent per request (lower uses more tokens but increases number of suggestions)
  split_threshold = 100,
  -- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
  highlight = {
    icon = '', -- ''
    group = 'BackseatText',
  },
})
