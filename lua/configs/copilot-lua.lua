local default_cfg = {
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
    layout = {
      position = "bottom", -- | top | left | right | horizontal | vertical
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  logger = {
    file = vim.fn.stdpath("log") .. "/copilot-lua.log",
    file_log_level = vim.log.levels.OFF,
    print_log_level = vim.log.levels.WARN,
    trace_lsp = "off", -- "off" | "messages" | "verbose"
    trace_lsp_progress = false,
    log_lsp_messages = false,
  },
  copilot_node_command = "node", -- Node.js version must be > 18.x
  workspace_folders = {},
  copilot_model = "", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
  root_dir = function()
    return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  end,
  should_attach = nil, -- type is fun(bufnr: integer, bufname: string): boolean
}

require("copilot").setup({
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  server_opts_overrides = {
    -- trace = 'verbose',
    settings = {
      advanced = {
        listCount = 5, -- #completions for panel
        inlineSuggestCount = 5, -- #completions for getCompletions
      },
    },
  },
  suggestion = {
    enabled = false,
    auto_trigger = false,
    keymap = {
      -- accept = '<C-CR>',
      -- next = '<M-}>',
      -- prev = '<M-{>',
      -- dismiss = '<C-d>',
      accept_word = false,
      accept_line = false,
    },
  },
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      open = "<M-CR>",
      -- refresh = 'gr',
      refresh = false,
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.3,
    },
  },
  root_dir = function()
    return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  end,
  workspace_folders = { "/home/nicholas/.config/nvim" },
  copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
})

-- vim.keymap.set({ 'i', 'n' }, '<M-y>', function()
--   local panel = require('copilot.panel')
--   if panel.winid and vim.api.nvim_win_is_valid(panel.winid) then
--     panel.close()
--   else
--     panel.open()
--   end
-- end, { silent = true, desc = '[copilot] toggle panel' })

-- require("copilot.command").enable()
-- require("copilot.panel").accept()
-- require("copilot.panel").jump_next()
-- require("copilot.panel").jump_prev()
-- require("copilot.panel").open({postion, ratio})
-- require("copilot.panel").refresh()
-- local map = vim.keymap.set
-- local suggestions = require('copilot.suggestion')
-- stylua: ignore start
-- map("i", "å", suggestions.accept, { desc = "[copilot] accept suggestion", silent = true })
-- map("i", "<M-å>", suggestions.accept, { desc = "[copilot] accept suggestion", silent = true })
--
-- map("i", "∑", suggestions.accept_word, { desc = "[copilot] accept word", silent = true })
-- map("i", "<M-∑>", suggestions.accept_word, { desc = "[copilot] accept word", silent = true })
--
-- map("i", "¬", suggestions.accept_line, { desc = "[copilot] accept line", silent = true })
-- map("i", "<M-¬>", suggestions.accept_line, { desc = "[copilot] accept line", silent = true })
--
-- map("i", "‘", suggestions.next, { desc = "[copilot] accept next", silent = true })
-- map("i", "<M-‘>", suggestions.next, { desc = "[copilot] accept next", silent = true })
--
-- map("i", "“", suggestions.prev, { desc = "[copilot] accept prev", silent = true })
-- map("i", "<M-“>", suggestions.prev, { desc = "[copilot] accept prev", silent = true })
-- stylua: ignore end
-- cmd = "Copilot",
-- event = "InsertEnter",
--     server_opts_overrides = {
--       -- settings = {
--       --   advanced = {
--       --     listCount = 10,         -- number of completions for panel
--       --     inlineSuggestCount = 3, -- number of completions for getCompletions
--       --   },
--       -- },
--     },
--
--   }
-- end,
