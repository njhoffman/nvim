-- https://github.com/Bryley/neoai.nvim/issues/44

-- vim.treesitter.language.register('markdown', 'neoai-output')

local options = {
  -- Below are the default options, feel free to override what you would like changed
  ui = {
    output_popup_text = 'NeoAI',
    input_popup_text = 'Prompt',
    width = 65, -- As percentage eg. 30%
    output_popup_height = 85, -- As percentage eg. 80%
    submit = '<Enter>', -- Key binding to submit the prompt
  },
  models = {
    {
      name = 'openai',
      model = 'gpt-4-turbo',
      -- params = {
      --   top_p, top_k, temperature, frequency_penalty, presence_penalty
      --   max_tokens = 2048,
      -- },
    },
  },
  register_output = {
    ['g'] = function(output)
      return output
    end,
    ['c'] = require('neoai.utils').extract_code_snippets,
  },
  inject = {
    cutoff_width = 75,
  },
  prompts = {
    context_prompt = function(context)
      return "Hey, I'd like to provide some context for future "
        .. 'messages. Here is the code/text that I want to refer '
        .. 'to in our upcoming conversations:\n\n'
        .. context
    end,
  },
  mappings = {
    ['select_up'] = '<C-t>',
    ['select_down'] = '<C-t>',
  },
  api_key = {
    env = 'OPENAI_API_KEY',
    value = nil,
  },
  shortcuts = {
    {
      name = 'textify',
      key = '<leader>as',
      desc = 'fix text with AI',
      use_context = true,
      prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
      modes = { 'v' },
      strip_function = nil,
    },
    {
      name = 'gitcommit',
      key = '<leader>ag',
      desc = 'generate git commit message',
      use_context = false,
      prompt = function()
        return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system('git diff --cached')
      end,
      modes = { 'n' },
      strip_function = nil,
    },
  },
}

-- content = 'Review this code change: ```\n' .. git_diff .. '\n```'
-- content = 'Write a terse commit message according to the Conventional Commits specification. Try to stay below 80 characters total. Staged git diff: ```\n' .. git_diff .. '\n```'
-- TODO
-- shortcuts = {
--     {
--       name = "a_user_custom_shortcut",
--       system_message = "you are an expert {language} developer",
--       prompt = "the prompt here",
--       model_params = {
--         temperature = 0.5,
--         other_model_parameters = 0.2,
--       },
--       inject_mode = 'append' -- or 'replace',
--       only_code_snippet = true -- select the first code snippet only in the answer
--     }
--   }
--
return options
