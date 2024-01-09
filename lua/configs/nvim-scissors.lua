-- default settings
local default_cfg = {
  snippetDir = vim.fn.stdpath('config') .. '/snippets',
  editSnippetPopup = {
    height = 0.4, -- relative to the window, number between 0 and 1
    width = 0.6,
    border = 'rounded',
    keymaps = {
      cancel = 'q',
      saveChanges = '<CR>',
      goBackToSearch = '<BS>',
      delete = '<C-BS>',
      openInFile = '<C-o>',
      insertNextToken = '<C-t>', -- works in insert & normal mode
    },
  },
  -- `none` writes as a minified json file using `:h vim.encode.json`.
  -- `yq`/`jq` ensure formatted & sorted json files, which is relevant when
  -- you version control your snippets.
  jsonFormatter = 'none', -- "yq"|"jq"|"none"
}

local cfg = {}
require('scissors').setup({})

-- vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
-- -- When used in visual mode prefills the selection as body.
-- vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)
