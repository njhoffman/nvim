local f = io.open(vim.fn.expand('$XDG_CONFIG_HOME') .. '/openai')
if f then
  vim.env.OPENAI_API_KEY = f:read()
  f:close()
end

local defaults = {
  api_key_cmd = nil,
  yank_register = '+',
  edit_with_instructions = {
    diff = false,
    keymaps = {
      close = '<C-c>',
      accept = '<C-y>',
      toggle_diff = '<C-d>',
      toggle_settings = '<C-o>',
      cycle_windows = '<Tab>',
      use_output_as_input = '<C-i>',
    },
  },
  chat = {
    -- welcome_message = WELCOME_MESSAGE,
    loading_text = 'Loading, please wait ...',
    question_sign = '', -- 🙂
    answer_sign = 'ﮧ', -- 🤖
    max_line_length = 120,
    sessions_window = {
      border = {
        style = 'rounded',
        text = {
          top = ' Sessions ',
        },
      },
      win_options = {
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
      },
    },
    keymaps = {
      close = { '<C-c>' },
      yank_last = '<C-y>',
      yank_last_code = '<M-y>',
      scroll_up = '<C-u>',
      scroll_down = '<C-d>',
      new_session = '<C-n>',
      cycle_windows = '<Tab>',
      cycle_modes = '<C-f>',
      next_message = '<C-j>',
      prev_message = '<C-k>',
      select_session = '<Space>',
      rename_session = 'r',
      delete_session = 'd',
      draft_message = '<C-d>',
      edit_message = 'e',
      delete_message = 'd',
      toggle_settings = '<C-o>',
      toggle_message_role = '<C-r>',
      toggle_system_role_open = '<C-s>',
      stop_generating = '<C-x>',
    },
  },
  popup_layout = {
    default = 'center',
    center = {
      width = '80%',
      height = '80%',
    },
    right = {
      width = '30%',
      width_settings_open = '50%',
    },
  },
  popup_window = {
    border = {
      highlight = 'FloatBorder',
      style = 'rounded',
      text = {
        top = ' ChatGPT ',
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = '1',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
    buf_options = {
      filetype = 'markdown',
    },
  },
  system_window = {
    border = {
      highlight = 'FloatBorder',
      style = 'rounded',
      text = {
        top = ' SYSTEM ',
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = '2',
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  },
  popup_input = {
    prompt = '  ',
    border = {
      highlight = 'FloatBorder',
      style = 'rounded',
      text = {
        top_align = 'center',
        top = ' Prompt ',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
    submit = '<C-Enter>',
    submit_n = '<Enter>',
    max_visible_lines = 20,
  },
  settings_window = {
    border = {
      style = 'rounded',
      text = {
        top = ' Settings ',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  },
  openai_params = {
    model = 'gpt-3.5-turbo ',
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 300,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = 'gpt-3.5-turbo',
    frequency_penalty = 0,
    presence_penalty = 0,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  use_openai_functions_for_edits = false,
  actions_paths = {},
  show_quickfixes_cmd = 'Trouble quickfix',
  predefined_chat_gpt_prompts = 'https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv',
}

local cfg = {
  chat = {
    popup_layout = {
      default = 'right',
    },
    keymaps = {
      close = {
        -- '<esc>',
        '<C-c>',
        '<esc><esc>',
        '<M-{>',
      },
      cycle_modes = { '<M-}>' },
    },
  },
  openai_params = {
    model = 'gpt-4',
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 1000,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = 'gpt-4',
    frequency_penalty = 0,
    presence_penalty = 0,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
}

return cfg
-- MODEL	DESCRIPTION	CONTEXT WINDOW	TRAINING DATA
-- gpt-4-1106-preview
--     GPT-4 TurboNew
--     The latest GPT-4 model with improved instruction following, JSON mode, reproducible outputs, parallel function calling, and more. Returns a maximum of 4,096 output tokens. This preview model is not yet suited for production traffic. Learn more.	128,000 tokens	Up to Apr 2023
--     gpt-4-vision-preview	GPT-4 Turbo with visionNew
--     Ability to understand images, in addition to all other GPT-4 Turbo capabilties. Returns a maximum of 4,096 output tokens. This is a preview model version and not suited yet for production traffic. Learn more.	128,000 tokens	Up to Apr 2023
-- gpt-4         	      Currently points to gpt-4-0613. See continuous model upgrades.	8,192 tokens	Up to Sep 2021
-- gpt-4-32k	          Currently points to gpt-4-32k-0613. See continuous model upgrades.	32,768 tokens	Up to Sep 2021
-- gpt-4-0613	          Snapshot of gpt-4 from June 13th 2023 with improved function calling support.	8,192 tokens	Up to Sep 2021
-- gpt-4-32k-0613	      Snapshot of gpt-4-32k from June 13th 2023 with improved function calling support.	32,768 tokens	Up to Sep 2021
-- gpt-3.5-turbo-1106	  Updated GPT 3.5 TurboNew
--                      The latest GPT-3.5 Turbo model with improved instruction following, JSON mode, reproducible outputs, parallel function calling, and more. Returns a maximum of 4,096 output tokens. Learn more.	16,385 tokens	Up to Sep 2021
-- gpt-3.5-turbo	      Currently points to gpt-3.5-turbo-0613. Will point to gpt-3.5-turbo-1106 starting Dec 11, 2023. See continuous model upgrades.	4,096 tokens	Up to Sep 2021
-- gpt-3.5-turbo-16k	  Currently points to gpt-3.5-turbo-0613. Will point to gpt-3.5-turbo-1106 starting Dec 11, 2023. See continuous model upgrades.	16,385 tokens	Up to Sep 2021
-- gpt-3.5-turbo-instruct	Similar capabilities as text-davinci-003 but compatible with legacy Completions endpoint and not Chat Completions.	4,096 tokens	Up to Sep 2021
