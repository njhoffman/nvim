local map = require("mapper").map

local M = {}

local fmt = string.format
local default_model = "google/gemini-2.0-flash-001"
local available_models = {
  "google/gemini-2.0-flash-001",
  "google/gemini-2.5-pro-preview-03-25",
  "anthropic/claude-3.7-sonnet",
  "anthropic/claude-3.5-sonnet",
  "openai/gpt-4o-mini",
  "anthropic/claude-sonnet-4",
}

local Path = require("plenary.path")
local config = {
  current_model = default_model,
  config_dir = "~/.local/share/nvim/codecompanion-openrouter",
  config_name = "config.json",
}

function open_textarea(callback)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = "markdown"
  local width = 100
  local height = 30
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)

  map("n", "<CR>", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.api.nvim_win_close(win, true)
    callback(lines[1], table.concat(lines, "\n"))
  end, { buffer = buf })

  -- Optional: Esc to cancel
  map("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
    vim.notify("Adding reference canceled")
  end, { buffer = buf })
end

-- Internal function to get Path object
local function get_config_path(cfg)
  local dir = Path:new(vim.fn.expand(cfg.config_dir))
  return dir:joinpath(cfg.config_name)
end

-- Initialize config directory & file
function M.init_config()
  local config_path = get_config_path(config)

  -- Create directory if not exists
  config_path:parent():mkdir({ parents = true })

  -- Save default config only if file doesn't exist
  if not config_path:exists() then
    M.save_config(config)
  end

  local latest_config = M.read_config()
  config = latest_config
end

-- Save config to file (overwrites existing file)
function M.save_config(cfg)
  local config_path = get_config_path(cfg)

  -- Remove non-persistable fields
  local copy = vim.tbl_deep_extend("force", {}, cfg)
  copy.config_dir = nil
  copy.config_name = nil

  config_path:write(vim.fn.json_encode(copy), "w")
end

-- Read config from file
function M.read_config()
  local config_path = get_config_path(config)
  if not config_path:exists() then
    return nil, "Config file does not exist"
  end

  local content = config_path:read()
  local ok, parsed = pcall(vim.fn.json_decode, content)
  if not ok then
    return nil, "Failed to parse config"
  end

  -- Reattach config_dir and config_name if needed
  parsed.config_dir = config.config_dir
  parsed.config_name = config.config_name
  return parsed
end

function M.select_model()
  vim.ui.select(available_models, {
    prompt = "Select  Model:",
  }, function(choice)
    if choice then
      config.current_model = choice
      M.save_config(config)
      vim.notify("Selected model: " .. config.current_model)
      M.init_config()
    end
  end)
end

function M.get_current_model()
  return config.current_model
end

---@param chat CodeCompanion.Chat
---@param id string
---@param input string
function M.add_image(chat, id, input)
  local new_message = {
    {
      type = "text",
      text = "the user is sharing this image with you. be ready for a query or task regarding this image",
    },
    {
      type = "image_url",
      image_url = {
        url = input,
      },
    },
  }

  local constants = require("codecompanion.config").config.constants
  chat:add_message({
    role = constants.USER_ROLE,
    content = vim.fn.json_encode(new_message),
  }, { reference = id, visible = false })

  chat.references:add({
    id = id,
    source = "adapter.image_url",
  })
end

---@Param chat CodeCompanion.Chat
function M.slash_paste_image(chat)
  local clipboard = require("img-clip.clipboard")
  local paste = require("img-clip.paste")
  if not clipboard.content_is_image() then
    vim.notify("clipboard content is not an image", vim.log.levels.WARN)
    return
  end
  local prefix = paste.get_base64_prefix()
  local base64res = clipboard.get_base64_encoded_image()
  local url = prefix .. base64res
  local hash = vim.fn.sha256(url)
  local id = "<pasted_image>" .. hash:sub(1, 16) .. "</pasted_image>"
  M.add_image(chat, id, url)
end

---@param chat CodeCompanion.Chat
function M.slash_add_image_url(chat)
  local function callback(input)
    if input then
      local id = "<image_url>" .. input .. "</image_url>"
      M.add_image(chat, id, input)
    end
  end
  vim.ui.input({ prompt = "> Enter image url", default = "", completion = "dir" }, callback)
end

function M.slash_md_reference(chat)
  local constants = require("codecompanion.config").config.constants
  ---@type TextareaCallback
  local callback = function(first_line, full_text)
    local id = "<markdown>" .. first_line .. "</markdown>"
    local prompt = [[

			The user is sharing a markdown text with you, it can be a PRD, a description of a task, or even an openapi contract.
      if it is description of a task or a product you should follow the description there and remind the user if some implementation is not adheere to the shared document.
      if it is openapi contract you should remember it and when implementing a form of rest api call use that as reference
      Here is the content of the file
    ]]
    local content = fmt(
      [[%s:

```%s
%s
```]],
      "markdown",
      prompt,
      full_text
    )
    chat:add_message({
      role = constants.USER_ROLE,
      content = content,
    }, { reference = id, visible = false })

    chat.references:add({
      id = id,
      source = "codecompanion.strategies.chat.slash_commands.file",
    })
  end

  open_textarea(callback)
end

function M.get_slash_commands()
  return {
    ["image_url"] = {
      callback = M.slash_add_image_url,
      description = "add image via url",
    },
    ["image_paste"] = {
      callback = M.slash_paste_image,
      description = "add image from clipboard",
    },
    ["reference"] = {
      callback = M.slash_md_reference,
      description = "Add markdown reference",
    },
  }
end

function M.get_keymaps()
  return {
    submit = {
      modes = { n = "<CR>" },
      description = "Submit",
      callback = function(chat)
        local config = M.read_config()
        chat:apply_model(config.current_model)
        chat:submit()
      end,
    },
  }
end

function M.get_extensions()
  return {
    history = {
      enabled = true,
      opts = {
        -- Keymap to open history from chat buffer (default: gh)
        keymap = "gh",
        -- Keymap to save the current chat manually (when auto_save is disabled)
        save_chat_keymap = "sc",
        -- Save all chats by default (disable to save only manually using 'sc')
        auto_save = true,
        -- Number of days after which chats are automatically deleted (0 to disable)
        expiration_days = 0,
        -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
        picker = "telescope",
        ---Automatically generate titles for new chats
        auto_generate_title = true,
        title_generation_opts = {
          ---Adapter for generating titles (defaults to active chat's adapter)
          adapter = nil, -- e.g "copilot"
          ---Model for generating titles (defaults to active chat's model)
          model = nil, -- e.g "gpt-4o"
        },
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = true,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = true,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = false,
      },
    },
  }
end

function M.get_adapter()
  local openai = require("codecompanion.adapters.openai")
  return require("codecompanion.adapters").extend("openai_compatible", {
    env = {
      url = "https://openrouter.ai/api",
      api_key = "OPENROUTER_API_KEY",
      chat_url = "/v1/chat/completions",
    },
    handlers = {
      form_parameters = function(self, params, messages)
        local result = openai.handlers.form_parameters(self, params, messages)
        return result
      end,
      form_messages = function(self, messages)
        local result = openai.handlers.form_messages(self, messages)

        local fun = require("hanipcode.local.fun")
        fun.map(result.messages, function(v)
          local ok, json_res = pcall(function()
            return vim.fn.json_decode(v.content)
          end, "not a json")
          if ok then
            v.content = json_res
            return v
          end
          return v
        end)

        return result
      end,
    },
    schema = {
      model = {
        default = config.current_model,
      },
    },
  })
end
M.others = {
  openrouter_claude = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "https://openrouter.ai/api",
        api_key = "OPENROUTER_API_KEY",
        chat_url = "/v1/chat/completions",
      },
      schema = {
        model = {
          default = "anthropic/claude-3.7-sonnet",
        },
      },
    })
  end,
  copilot_chat = function()
    return require("codecompanion.adapters").extend("copilot", {
      schema = {
        model = {
          default = "claude-3.5-sonnet",
        },
      },
    })
  end,
  copilot_inline = function()
    return require("codecompanion.adapters").extend("copilot", {
      schema = {
        model = {
          default = "gemini-2.0-flash-001",
        },
      },
    })
  end,
  fireworks = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "https://api.fireworks.ai/inference/v1",
        api_key = vim.env.NEOVIM_FIREWORKS_API_KEY,
        chat_url = "/chat/completions",
      },
      schema = {
        model = {
          default = "accounts/fireworks/models/deepseek-v3",
        },
        max_tokens = {
          default = 128000,
        },
      },
    })
  end,
  ollama_dynamic = function()
    return require("codecompanion.adapters").extend("ollama", {
      schema = {
        model = {
          default = preferred_model_picker({
            "qwen2.5-coder:14b",
            "qwen2.5-coder:7b",
            "qwen2.5-coder:3b",
            "qwen2.5-coder:1.5b",
            "qwen2.5-coder:0.5b",
          }),
        },
      },
    })
  end,
  -- remote ollama
  ollama = function()
    return require("codecompanion.adapters").extend("ollama", {
      env = {
        url = "https://my_ollama_url",
        api_key = "OLLAMA_API_KEY",
      },
      headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer ${api_key}",
      },
      parameters = {
        sync = true,
      },
    })
  end,
  my_openai = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "http[s]://open_compatible_ai_url", -- optional: default value is ollama url http://127.0.0.1:11434
        api_key = "OpenAI_API_KEY", -- optional: if your endpoint is authenticated
        chat_url = "/v1/chat/completions", -- optional: default value, override if different
        models_endpoint = "/v1/models", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
      },
      schema = {
        model = {
          default = "deepseek-r1-671b", -- define llm model to be used
        },
        temperature = {
          order = 2,
          mapping = "parameters",
          type = "number",
          optional = true,
          default = 0.8,
          desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
          validate = function(n)
            return n >= 0 and n <= 2, "Must be between 0 and 2"
          end,
        },
        max_completion_tokens = {
          order = 3,
          mapping = "parameters",
          type = "integer",
          optional = true,
          default = nil,
          desc = "An upper bound for the number of tokens that can be generated for a completion.",
          validate = function(n)
            return n > 0, "Must be greater than 0"
          end,
        },
        stop = {
          order = 4,
          mapping = "parameters",
          type = "string",
          optional = true,
          default = nil,
          desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
          validate = function(s)
            return s:len() > 0, "Cannot be an empty string"
          end,
        },
        logit_bias = {
          order = 5,
          mapping = "parameters",
          type = "map",
          optional = true,
          default = nil,
          desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
          subtype_key = {
            type = "integer",
          },
          subtype = {
            type = "integer",
            validate = function(n)
              return n >= -100 and n <= 100, "Must be between -100 and 100"
            end,
          },
        },
      },
    })
  end,
}

M.available_adapters = {
  -- HTTP-based adapters ------------------------------------------------------
  http = {
    -- LLMs -------------------------------------------------------------------
    anthropic = "anthropic",
    azure_openai = "azure_openai",
    copilot = "copilot",
    deepseek = "deepseek",
    gemini = "gemini",
    githubmodels = "githubmodels",
    huggingface = "huggingface",
    novita = "novita",
    mistral = "mistral",
    ollama = "ollama",
    openai = "openai",
    xai = "xai",
    -- Non LLMs
    jina = "jina",
    tavily = "tavily",
    -- OPTIONS ----------------------------------------------------------------
    opts = {
      allow_insecure = false, -- Allow insecure connections?
      cache_models_for = 1800, -- Cache adapter models for this long (seconds)
      proxy = nil, -- [protocol://]host[:port] e.g. socks5://127.0.0.1:9999
      show_default_actions = true, -- Show the default actions in the action palette?
      show_default_prompt_library = true, -- Show the default prompt library in the action palette?
    },
  },
}

return M
