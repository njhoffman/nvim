-- require('llm').setup({
--   default_prompt? = .. , -- Prompt — modify the default prompt (`:Llm` with no argument)
--   hl_group? = '',        -- string — set the default highlight group of in-progress responses
--   prompts? = {}          -- table<string, Prompt>` — add prompt alternatives
--   join_undo? = false     -- boolean — join streaming response text as a single `u` undo. use if you intend to wait for responses to finish before editing other text, as edits during streaming will also be undone.
-- })

local util = require('llm.util')
local prompts = require('./configs/llm/prompts')

require('llm').setup({
  hl_group = 'Substitute',
  prompts = prompts,
  join_undo = true,
  -- default_prompt = llamacpp.default_prompt,
  -- prompts = util.module.autoload('prompt_library'),

  -- prompts = require('llm.util').module.autoload('prompts'),
})
