local opts = {
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
  },
  strategies = {
    -- chat = { adapter = "anthropic", },
    -- inline = { adapter = "copilot", },
    -- cmd = { adapter = "deepseek", }
    chat = {
      adapter = "openai",
      -- adapter = {
      --   name = "copilot",
      --   model = "claude-sonnet-4-20250514",
      -- },

      --     roles = {
      --       ---The header name for the LLM's messages
      --       ---@type string|fun(adapter: CodeCompanion.Adapter): string
      --       llm = function(adapter)
      --         return "CodeCompanion (" .. adapter.formatted_name .. ")"
      --       end,
      --
      --       ---The header name for your messages
      --       ---@type string
      --       user = "Me",
      --     },
      -- adapter = 'openrouter',
      -- keymaps = {
      --   submit = {
      --     modes = { n = '<CR>' },
      --     description = 'Submit',
      --     callback = function(chat)
      --       chat:apply_model(current_model)
      --       chat:submit()
      --     end,
      --   },
      -- },
    },
  },
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        schema = {
          model = {
            default = "gpt-4.1",
          },
        },
      })
    end,
  },
  opts = {
    -- Set debug logging
    log_level = "INFO",
  },
  -- adapters = { openrouter = adapters.get_adapter() },
  -- extensions = adapters.get_extensions(),
  extensions = {
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
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = false,
        -- require("codecompanion").extensions.history:
        -- -- Get the storage location for saved chats
        -- get_location(): string?
        --
        -- -- Save a chat to storage (uses last chat if none provided)
        -- save_chat(chat?: CodeCompanion.Chat)
        --
        -- -- Get metadata for all saved chats
        -- get_chats(): table<string, ChatIndexData>
        --
        -- -- Load a specific chat by its save_id
        -- load_chat(save_id: string): ChatData?
        --
        -- -- Delete a chat by its save_id
        -- delete_chat(save_id: string): boolean
        -- :CodeCompanionHistory - Open the history browser
        -- ⌨️ Chat Buffer Keymaps​
        -- gh - Open history browser (customizable via opts.keymap)
        -- sc - Save current chat manually (customizable via opts.save_chat_keymap)
        -- 📚 History Browser​
        -- The history browser shows all your saved chats with:
        --
        -- Title (auto-generated or custom)
        -- Last updated time
        -- Preview of chat contents
        -- Actions in history browser:
        --
        -- <CR> - Open selected chat
        -- Normal mode:
        -- d - Delete selected chat(s)
        -- r - Rename selected chat
        -- Insert mode:
        -- <M-d> (Alt+d) - Delete selected chat(s)
        -- <M-r> (Alt+r) - Rename selected chat
        -- You can use <Tab> to select multiple chats for deletion.
      },
    },
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true, -- Show mcp tool results in chat
        make_vars = true, -- Convert resources to #variables
        make_slash_commands = true, -- Add prompts as /slash commands
        extensions = {
          avante = {
            enabled = true,
            make_slash_commands = true,
          },
        },
      },
    },
    -- vectorcode = {
    --   -- tool group: @vectorcode_toolbox: ls, query, vectorise
    --   -- @vectorcode_ls: an equivalent of vectorcode ls command;
    --   -- @vectorcode_query: an equivalent of vectorcode query command;
    --   -- @vectorcode_vectorise: an equivalent of vectorcode vectorise command;
    --   -- @vectorcode_files_ls: an equivalent of vectorcode files ls command;
    --   -- @vectorcode_files_rm: an equivalent of vectorcode files rm command.
    --   opts = {
    --     tool_group = {
    --       -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
    --       enabled = true,
    --       -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
    --       -- if you use @vectorcode_vectorise, it'll be very handy to include `file_search` here.
    --       extras = {},
    --       collapse = false, -- whether the individual tools should be shown in the chat
    --     },
    --     tool_opts = {
    --       ["*"] = {},
    --       ls = {},
    --       vectorise = {},
    --       query = {
    --         max_num = { chunk = -1, document = -1 },
    --         default_num = { chunk = 50, document = 10 },
    --         include_stderr = false,
    --         use_lsp = false,
    --         no_duplicate = true,
    --         chunk_mode = false,
    --         summarise = {
    --           enabled = false,
    --           adapter = nil,
    --           query_augmented = true,
    --         },
    --       },
    --       files_ls = {},
    --       files_rm = {},
    --     },
    --   },
    -- },
  },
}

require("codecompanion").setup(opts)

-- CodeCompanionChatHeader - The headers in the chat buffer
-- CodeCompanionChatSeparator - Separator between headings in the chat buffer
-- CodeCompanionChatTokens - Virtual text in the chat buffer showing the token count
-- CodeCompanionChatTool - Tools in the chat buffer
-- CodeCompanionChatToolGroups - Tool groups in the chat buffer
-- CodeCompanionChatVariable - Variables in the chat buffer
-- CodeCompanionVirtualText - All other virtual text in the plugin
