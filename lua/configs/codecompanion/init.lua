-- COPYING CODE FROM A CHAT BUFFER ~
-- The fastest way to copy an LLM’s code output is with `gy`. This will yank the
-- nearest codeblock.

-- APPLYING AN LLM'S EDITS TO A BUFFER OR FILE ~
-- The |codecompanion-usage-chat-buffer-agents-files| tool, combined with the
-- |codecompanion-usage-chat-buffer-variables.html-buffer| variable or
-- |codecompanion-usage-chat-buffer-slash-commands.html-buffer| slash command,
-- enables an LLM to modify code in a Neovim buffer. This is especially useful if
-- you do not wish to manually apply an LLM’s suggestions yourself. Simply tag
-- it in the chat buffer with `@files` or `@insert_edit_into_file`.
--
-- RUN TESTS FROM THE CHAT BUFFER ~
-- The |codecompanion-usage-chat-buffer-agents-cmd-runner| tool enables an LLM to
-- execute commands on your machine. This can be useful if you wish the LLM to run
-- a test suite on your behalf and give insight on failing cases. Simply tag the
-- `@cmd_runner` in the chat buffer and ask it run your tests.
--
--
-- NAVIGATING BETWEEN RESPONSES IN THE CHAT BUFFER ~
-- You can quickly move between responses in the chat buffer using `[[` or `]]`.
--
-- QUICKLY ACCESSING A CHAT BUFFER ~
-- The `:CodeCompanionChat Toggle` command will automatically create a chat buffer
-- if one doesn’t exist, open the last chat buffer or hide the current chat buffer.
-- When in a chat buffer, you can cycle between other chat buffers with `{` or `}`.

-- - `<CR>|<C-s>` to send a message to the LLM
-- - `<C-c>` to close the chat buffer
-- - `q` to stop the current request
-- - `ga` to change the adapter for the currentchat
-- - `gc` to insert a codeblock in the chat buffer
-- - `gd` to view/debug the chat buffer’s contents
-- - `gf` to fold any codeblocks in the chat buffer
-- - `gp` to pin a reference to the chat buffer
-- - `gw` to watch a referenced buffer
-- - `gr` to regenerate the last response
-- - `gR` to go to the file under cursor. If the file is already opened, it’ll jump
--     to the existing window. Otherwise, it’ll be opened in a new tab.
-- - `gs` to toggle the system prompt on/off
-- - `gS` to show copilot usage stats
-- - `gta` to toggle auto tool mode
-- - `gx` to clear the chat buffer’s contents
-- - `gy` to yank the last codeblock in the chat buffer
-- - `[[` to move to the previous header
-- - `]]` to move to the next header
-- - `{` to move to the previous chat
-- - `}` to move to the next chat
--

local cfg = {
  extensions = require("configs.codecompanion.extensions"),
  prompt_library = require("configs.codecompanion.prompts"),
  -- adapters = {
  --   anthropic = function()
  --     return require("codecompanion.adapters").extend("anthropic", {
  --       -- env = { api_key = "cmd:op read op://personal/Anthropic_API/credential --no-newline", },
  --       schema = {
  --         extended_thinking = {
  --           default = true,
  --         },
  --       },
  --     })
  --   end,
  --   openai = function()
  --     return require("codecompanion.adapters").extend("openai", {
  --       opts = {
  --         stream = true,
  --       },
  --       -- env = { api_key = "cmd:op read op://personal/OpenAI_API/credential --no-newline", },
  --       schema = {
  --         model = {
  --           default = function()
  --             return "gpt-4.1"
  --           end,
  --         },
  --       },
  --     })
  --   end,
  -- },
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
    icons = {
      loading = " ",
      warning = " ",
    },
    chat = {
      -- icons = { buffer_pin = " ", buffer_watch = "󰂥 ", tool_success = "", tool_failure = "", },
      -- debug_window = { width = vim.o.columns - 5, height = vim.o.lines - 2 },
      window = {
        -- layout = "vertical", -- float|vertical|horizontal|buffer
        -- position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
        -- position = "right",
        -- layout = "float",
        border = "rounded",
        width = 0.35,
        -- height = 0.8,
        -- width = 0.45, -- using "auto" will allow full_height buffers to act like normal buffers
        -- relative = "editor",
        -- full_height = true,
        opts = {
          -- breakindent = true,
          -- cursorcolumn = false,
          -- cursorline = false,
          -- foldcolumn = "0",
          -- linebreak = true,
          -- list = false,
          -- numberwidth = 1,
          -- signcolumn = "no",
          -- spell = false,
          relativenumber = false,
          number = false,
          wrap = false,
        },
      },
      -- auto_scroll = true, -- Automatically scroll down and place the cursor at the end
      -- intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
      intro_message = "#:vars @:tools /:commands ✨! Press ? for options",

      show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
      -- separator = "─", -- The separator between the different messages in the chat buffer

      -- show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
      show_settings = true, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      start_in_insert_mode = true, -- Open the chat buffer in insert mode?

      ---@param tokens number
      ---@param adapter CodeCompanion.Adapter
      token_count = function(tokens, adapter) -- The function to display the token count
        return " (" .. tokens .. " tokens)"
      end,
    },
    diff = {
      -- enabled = true,
      -- close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
      -- layout = "vertical", -- vertical|horizontal split for default provider
      -- opts = {
      --   "internal",
      --   "filler",
      --   "closeoff",
      --   "algorithm:patience",
      --   "followwrap",
      --   "linematch:120",
      -- },
      provider = "mini_diff", -- default|mini_diff
    },
  },
  interactions = {
    chat = {
      adapter = "anthropic",
      tools = {
        groups = {
          ["github_pr_workflow"] = {
            description = "GitHub operations from issue to PR",
            tools = {
              -- File operations
              "neovim__read_multiple_files",
              "neovim__write_file",
              "neovim__edit_file",
              -- GitHub operations
              "github__list_issues",
              "github__get_issue",
              "github__get_issue_comments",
              "github__create_issue",
              "github__create_pull_request",
              "github__get_file_contents",
              "github__create_or_update_file",
              "github__search_code",
            },
          },
        },
      },
      keymaps = {
        send = {
          modes = {
            i = { "<C-CR>", "<C-s>" },
          },
        },
        completion = {
          modes = {
            i = "<C-x>",
          },
        },
      },
      slash_commands = {
        ["buffer"] = {
          keymaps = {
            modes = {
              i = "<C-b>",
            },
          },
        },
        ["fetch"] = {
          keymaps = {
            modes = {
              i = "<C-f>",
            },
          },
        },
        ["help"] = {
          opts = {
            max_lines = 1000,
          },
        },
      },
    },

    inline = {
      adapter = "anthropic",
      --           adapter = { name = "copilot", model = "gpt-4.1", },
      -- layout = 'vertical' -- vertical, horizontal, buffer
      keymaps = {
        accept_change = {
          modes = { n = "ga" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "gr" },
          description = "Reject the suggested change",
        },
      },
    },
    cmd = { adapter = "deepseek" },

    -- https://github.com/olimorris/codecompanion.nvim/discussions/1013
    -- chat = {
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
    -- },
  },
  opts = {
    completion_provider = "cmp",
    -- Set debug logging
    log_level = "INFO",
  },
}

require("codecompanion").setup(cfg)

vim.cmd.cabbr("cc", "CodeCompanion")
vim.cmd.cabbr("ccc", "CodeCompanionChat")
vim.cmd.cabbr("cca", "CodeCompanionActions")
vim.cmd.cabbr("cch", "CodeCompanionHistory")
-- vim.cmd.cabbr("ccm", "CodeCompanionModel")

-- CodeCompanionChatInfo - Information messages in the chat buffer
-- CodeCompanionChatError - Error messages in the chat buffer
-- CodeCompanionChatWarn - Warning messages in the chat buffer
-- CodeCompanionChatSubtext - Messages that appear under the information, error or warning messages in the chat buffer
-- CodeCompanionChatHeader - The headers in the chat buffer
-- CodeCompanionChatSeparator - Separator between headings in the chat buffer
-- CodeCompanionChatTokens - Virtual text in the chat buffer showing the token count
-- CodeCompanionChatTool - Tools in the chat buffer
-- CodeCompanionChatToolGroups - Tool groups in the chat buffer
-- CodeCompanionChatVariable - Variables in the chat buffer
-- CodeCompanionVirtualText - All other virtual text in the plugin

-- local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

-- vim.api.nvim_create_autocmd({ "User" }, {
--   pattern = "CodeCompanionRequest*",
--   group = group,
--   callback = function(request)
--     if request.match == "CodeCompanionRequestStarted" then
--       print(vim.inspect(request.data))
--       print(require("codecompanion").buf_get_chat(request.data.bufnr))
--     end
--   end,
-- })

local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionInline*",
  group = group,
  callback = function(request)
    if request.match == "CodeCompanionInlineFinished" then
      -- Format the buffer after the inline request has completed
      require("conform").format({ bufnr = request.buf })
    end
  end,
})

-- https://github.com/olimorris/codecompanion.nvim/discussions/641
vim.api.nvim_create_user_command("CodeCompanionShare", function(opts)
  require("codecompanion").last_chat().references:add({
    id = opts.args,
    path = opts.args,
    source = "codecompanion.strategies.chat.slash_commands.file",
    opts = {
      pinned = true,
    },
  })
end, { nargs = 1 })

-- EVENTS
-- - `CodeCompanionChatCreated` - Fired after a chat has been created for the first time
-- - `CodeCompanionChatOpened` - Fired after a chat has been opened
-- - `CodeCompanionChatHidden` - Fired after a chat has been hidden
-- - `CodeCompanionChatClosed` - Fired after a chat has been permanently closed
-- - `CodeCompanionChatSubmitted` - Fired after a chat has been submitted
-- - `CodeCompanionChatStopped` - Fired after a chat has been stopped
-- - `CodeCompanionChatCleared` - Fired after a chat has been cleared
-- - `CodeCompanionChatAdapter` - Fired after the adapter has been set in the chat
-- - `CodeCompanionChatModel` - Fired after the model has been set in the chat
-- - `CodeCompanionChatPin` - Fired after a pinned reference has been updated in the messages table
-- - `CodeCompanionAgentStarted` - Fired when an agent has been initiated to run tools
-- - `CodeCompanionAgentFinished` - Fired when an agent has finished running all tools
-- - `CodeCompanionToolAdded` - Fired when a tool has been added to a chat
-- - `CodeCompanionToolStarted` - Fired when a tool has started executing
-- - `CodeCompanionToolFinished` - Fired when a tool has finished executing
-- - `CodeCompanionInlineStarted` - Fired at the start of the Inline strategy
-- - `CodeCompanionInlineFinished` - Fired at the end of the Inline strategy
-- - `CodeCompanionRequestStarted` - Fired at the start of any API request
-- - `CodeCompanionRequestStreaming` - Fired at the start of a streaming API request
-- - `CodeCompanionRequestFinished` - Fired at the end of any API request
-- - `CodeCompanionDiffAttached` - Fired when in Diff mode
-- - `CodeCompanionDiffDetached` - Fired when exiting Diff mode
-- - `CodeCompanionDiffAccepted` - Fired when a user accepts a change
-- - `CodeCompanionDiffRejected` - Fired when a user rejects a change
--
