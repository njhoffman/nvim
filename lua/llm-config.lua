local util = require('llm.util')
local llm = require('llm')
local segment = require('llm.segment')
local providers = require('./llm-providers')
local prompts = require('./llm-prompts')

-- best model so far: codellama-13b-instruct.Q5_K_S.gguf
-- https://huggingface.co/TheBloke/CodeLlama-13B-Instruct-GGUF

local toRapPrompt = {
  provider = providers.openai,
  hl_group = 'Title',
  builder = function(input)
    return {
      messages = {
        {
          role = 'system',
          content = "Explain the code in 90's era rap lyrics",
        },
        {
          role = 'user',
          content = input,
        },
      },
    }
  end,
}

local defaultPrompt = {
  provider = providers.openai,
  builder = function(input)
    return {
      temperature = 0.3,
      max_tokens = 120,
      messages = {
        {
          role = 'system',
          content = 'You are helpful assistant.',
        },
        {
          role = 'user',
          content = input,
        },
      },
    }
  end,
}

local toSpanishPrompt = {
  provider = providers.openai,
  hl_group = 'SpecialComment',
  builder = function(input)
    return {
      messages = {
        {
          role = 'system',
          content = 'Translate to Spanish',
        },
        {
          role = 'user',
          content = input,
        },
      },
    }
  end,
  -- mode = segment.mode.REPLACE,
}
local toJavascriptPrompt = {
  provider = providers.openai,
  builder = function(input)
    return {
      messages = {
        { role = 'system', content = 'Convert the code to javascript' },
        { role = 'user', content = input },
      },
    }
  end,
}

-- stylua: ignore
local prompts = vim.tbl_extend('force', require('llm.prompts.starters'), {
  toRapPrompt        = toRapPrompt,
  toSpanishPrompt    = toSpanishPrompt,
  toJavascriptPrompt = toJavascriptPrompt,
  -- codePrompt = codePrompt,
  -- generalPrompt = generalPrompt,
  -- askPrompt = askPrompt,
  -- modifyPrompt = modifyPrompt,
  -- mistralPrompt = mistralPrompt,
  -- wizardPrompt = wizardPrompt,
  -- openAssistantPrompt = openAssistantPrompt,
})

return {
  default_prompt = defaultPrompt,
  hl_group = 'Substitute',
  prompts = prompts,
  join_undo = true,
}

-- prompts = require('llm.util').module.autoload('prompts'),
