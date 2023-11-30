---@diagnostic disable: unused-local, unused-function, undefined-field

local handler = require('configs.nvim-ufo-handler')

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.foldnestmax = "1"
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = 0 -- all folds closed
vim.o.foldlevelstart = 99 -- no folds closed
vim.o.foldenable = true
vim.o.foldmethod = 'manual'

-- Close all top-level folds
-- vim.keymap.set('n', 'zz', function()
--   vim.cmd('%foldclose')
-- end, { desc = '󰘖 Close toplevel folds' })

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = '󰘖 open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = '󰘖 close all folds' })
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = '󰘖 open folds except kinds' })
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = '󰘖 close folds with' }) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set('n', 'zK', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then
    -- choose one of coc.nvim and nvim lsp
    vim.lsp.buf.hover()
  end
end, { desc = '󰘖 peek folded lines under cursor' })

local toggle = 1
vim.keymap.set('n', 'Z', function()
  if toggle == 0 then
    require('ufo').openAllFolds()
    toggle = 1
  else
    require('ufo').closeAllFolds()
    toggle = 0
  end
end, { desc = '󰘖 toggle open/close folds' })

local foldlevel = 1
-- TODO: calculate maximum fold level
local inspect_level = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local msg = require('ufo.main').inspectBuf(bufnr)
  if not msg then
    vim.notify(('Buffer %d has not been attached.'):format(bufnr), vim.log.levels.ERROR)
  else
    table.insert(msg, 'FoldLevel: ' .. foldlevel)
    vim.notify(table.concat(msg, '\n'), vim.log.levels.INFO)
  end
end

-- vim.keymap.set("n", "<M-,>", function()
--   if foldlevel > 0 then
--     foldlevel = foldlevel - 1
--   end
--   require("ufo").closeFoldsWith(foldlevel)
-- end, { remap = true })
--
-- vim.keymap.set("n", "<M-.>", function()
--   foldlevel = foldlevel + 1
--   require("ufo").closeFoldsWith(foldlevel)
-- end, { remap = true })

local ftMap = {
  -- vim = 'indent',
  -- python = { 'indent' },
  -- lua = 'indent',
  -- javascript = 'indent',
  git = '',
}

local config = {
  enable_get_fold_virt_text = true,
  open_fold_hl_timeout = 100,
  fold_virt_text_handler = handler.virt_text,
  provider_selector = function(bufnr, filetype, buftype)
    -- return a table with string elements: 1st is name of main provider, 2nd is fallback
    -- return a string type: use ufo inner providers
    -- return a string in a table: like a string type above
    -- return empty string '': disable any providers
    -- return `nil`: use default value {'lsp', 'indent'}
    -- return a function: it will be involved and expected return `UfoFoldingRange[]|Promise`

    -- if you prefer treesitter provider rather than lsp,
    return { 'treesitter', 'indent' }
    -- return ftMap[filetype] -- or
  end,
  close_fold_kinds = { 'comment', 'imports' and 'region' },
  preview = {
    win_config = {
      border = 'rounded',
      winhighlight = 'Normal:Folded',
      winblend = 20,
    },
    mappings = {
      scrollU = '<C-u>',
      scrollD = '<C-d>',
    },
  },
}

require('ufo').setup(config)

-- local default_config = {
--   open_fold_hl_timeout = 400,
--   --Time in millisecond between the range to be highlgihted and to be cleared while opening the folded line, `0` value will disable the highlight
--   provider_selector = nil,
--   -- A function as a selector for fold providers. For now, there are 'lsp' and 'treesitter' as main provider, 'indent' as fallback provider]],
--   close_fold_kinds = {},
--   -- description = [[After the buffer is displayed (opened for the first time), close the folds whose range with `kind` field is included in this option. For now, only 'lsp' provider contain 'comment', 'imports' and 'region'.
--   fold_virt_text_handler = nil,
--   -- A function customize fold virt text, see ### Customize fold text
--   enable_get_fold_virt_text = false,
--   -- Enable a function with `lnum` as a parameter to capture the virtual text for the folded lines and export the function to `get_fold_virt_text` field of ctx table as 6th parameter in `fold_virt_text_handler`
--   preview = {
--     -- Configure the options for preview window and remap the keys for current buffer and preview buffer if the preview window is displayed. Never worry about the users's keymaps are overridden by ufo, ufo will save them and restore them if preview window is closed.]],
--     win_config = {
--       border = "rounded",
--       -- The border for preview window, `:h nvim_open_win() | call search('border:')`]],
--       winblend = 12,
--       -- The winblend for preview window, `:h winblend`]],
--       winhighlight = "Normal:Normal",
--       -- The winhighlight for preview window, `:h winhighlight
--       maxheight = 20,
--       -- The max height of preview window]],
--     },
--     -- mappings = { },
--   },
-- }
