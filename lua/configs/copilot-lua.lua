local default_cfg = {
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = '[[',
      jump_next = ']]',
      accept = '<CR>',
      refresh = 'gr',
      open = '<M-CR>',
    },
    layout = {
      position = 'bottom', -- | top | left | right
      ratio = 0.3,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = '<M-l>',
      accept_word = false,
      accept_line = false,
      next = '<M-]>',
      prev = '<M-[>',
      dismiss = '<C-]>',
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
    ['.'] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
}

require('copilot').setup({
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
    enabled = true,
    auto_trigger = false,
    keymap = {
      accept = '<C-CR>',
      accept_word = false,
      accept_line = false,
      next = '<M-}>',
      prev = '<M-{>',
      dismiss = '<C-d>',
    },
  },
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = '[[',
      jump_next = ']]',
      accept = '<CR>',
      -- refresh = 'gr',
      refresh = false,
      -- open = '<M-y>',
      open = false,
    },
    layout = {
      position = 'bottom', -- | top | left | right
      ratio = 0.3,
    },
  },
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
--
-- config = function()
--   require("copilot").setup {
--
--     filetypes = {
--       markdown = true,
--     },
--
--     panel = {
--       enabled = false,      -- default: true
--       auto_refresh = true,  -- default: false
--       keymap = {
--         jump_prev = "[[",   -- default: "[["
--         jump_next = "]]",   -- default: "]]"
--         accept = "<CR>",    -- default: "<CR>"
--         refresh = "gr",     -- default: "gr"
--         open = "<M-CR>",    -- default: "<M-CR>
--       },
--       layout = {
--         position = "bottom", -- default: "bottom"
--         ratio = 0.4,         -- default: 0.4
--       },
--     },
--
--     suggestion = {
--       enabled = true,          -- default: true
--       auto_trigger = true,     -- default: false
--       debounce = 75,           -- default: 75
--       keymap = {
--         accept      = "<C-t>", -- default: "<M-l>"
--         accept_word = "<C-w>", -- default: false
--         accept_line = "<C-f>", -- default: false
--         next        = "<C-g>", -- default: "<M-]>"
--         prev        = "<C-b>", -- default: "<M-[>"
--         dismiss     = "<C-x>", -- default: "<C-]>"
--       },
--     },
--
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
