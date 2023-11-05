local llamacpp = require('llm.providers.llamacpp')
local extract = require('llm.prompts.extract')
local openai = require('llm.providers.openai')

llamacpp.options = {
  server_start = {
    command = '/path/to/server',
    args = {
      '-m',
      '/path/to/model',
      '-c',
      4096,
      '-ngl',
      22,
    },
  },
}
-- configure default model params here for the provider
openai.initialize({
  model = 'gpt-3.5-turbo-0301',
  max_tokens = 400,
  temperature = 0.2,
})

return {
  llamacpp = llamacpp,
  openai = openai,
}
