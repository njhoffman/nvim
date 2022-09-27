-- use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds, {})
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, {})
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, {})
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, {}) -- closeAllFolds == closeFoldsWith(0)

-- Tell the server the capability of foldingRange, Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
local language_servers = { "gopls", "sumneko_lua"} -- like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
  require("lspconfig")[ls].setup({
    capabilities = capabilities,
    other_fields = ...,
  })
end

local default_config = {
  open_fold_hl_timeout = 400,
  --Time in millisecond between the range to be highlgihted and to be cleared while opening the folded line, `0` value will disable the highlight
  provider_selector = nil,
  -- A function as a selector for fold providers. For now, there are 'lsp' and 'treesitter' as main provider, 'indent' as fallback provider]],
  close_fold_kinds = {},
  -- description = [[After the buffer is displayed (opened for the first time), close the folds whose range with `kind` field is included in this option. For now, only 'lsp' provider contain 'comment', 'imports' and 'region'.
  fold_virt_text_handler = nil,
  -- A function customize fold virt text, see ### Customize fold text
  enable_get_fold_virt_text = false,
  -- Enable a function with `lnum` as a parameter to capture the virtual text for the folded lines and export the function to `get_fold_virt_text` field of ctx table as 6th parameter in `fold_virt_text_handler`
  preview = {
    -- Configure the options for preview window and remap the keys for current buffer and preview buffer if the preview window is displayed. Never worry about the users's keymaps are overridden by ufo, ufo will save them and restore them if preview window is closed.]],
    win_config = {
      border = "rounded",
      -- The border for preview window, `:h nvim_open_win() | call search('border:')`]],
      winblend = 12,
      -- The winblend for preview window, `:h winblend`]],
      winhighlight = "Normal:Normal",
      -- The winhighlight for preview window, `:h winhighlight
      maxheight = 20,
      -- The max height of preview window]],
    },
    -- mappings = { },
  },
}

local config = { preview = { winblend = 20 } } or default_config
require("ufo").setup(config)

-- Option 3: treesitter as a main provider instead
-- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
-- use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
-- require("ufo").setup({
--   provider_selector = function(bufnr, filetype, buftype)
--     return { "treesitter", "indent" }
--   end,
-- })
-- --
