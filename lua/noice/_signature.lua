-- local Docs = require("noice.lsp.docs")
-- Docs.show(...)

-- make the whole back bar of the title background
-- inside  the signcolumns at least
-- PopupBorder guifg=#332222
-- Popup  guibg=#00061a

-- vim.api.nvim__complete_set(index, opts)

---@param message NoiceMessage
---@param stay? fun():boolean
function M.show(message, stay)
  M.autohide()
  message.opts.timeout = 100
  message.opts.keep = function()
    return true
  end
  message.opts.stay = stay
  for _, m in pairs(M._messages) do
    if m ~= message then
      M.hide(m)
    end
  end
  Manager.add(message)
end

-- hover, signature, message, documentation defaults
-- hover = {
--     enabled = true,
--     -- view = nil, -- when nil, use defaults from documentation
--     -- silent = false,
--     opts = {
--       focusable = true,
--       win_options = {
--         scrolloff = 0,
--         -- scrollback = 1,
--       },
--     }, -- merged with defaults from documentation
--   },

-- signature = {
--   enabled = true,
--   --   view = nil, -- when nil, use defaults from documentation
--   auto_open = {
--     enabled = true,
--     trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
--     luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
--     throttle = 200, -- Debounce lsp signature help request by 50ms
--   },
-- },

-- message = {
--   -- Messages shown by lsp servers
--   enabled = true,
--   view = 'notify',
--   opts = {},
-- },
-- -- defaults for hover and signature help
-- documentation = {
--   view = 'hover',
--   --  opts = { replace = true, render = "plain", format = { "{message}" },
--   --          win_options = { concealcursor = "n", conceallevel = 3 }, },
--   opts = {
--     lang = 'markdown',
--     replace = true,
--     render = 'plain',
--     format = { '{message}' },
--     win_options = {
--       concealcursor = 'n',
--       conceallevel = 3,
--       cursorline = false,
--     },
--   },
-- },

-- TODO: customize different
-- TODO: optionally switch to ray-x like functionalitty and optionally turn completions of
-- TODO: make a more minimal version, less repeating and line breaks, maybe split them off
-- TODO: make a smooth fade in animation that's not very intrusive
-- https://github.com/ray-x/lsp_signature.nvim
-- border = {
--   style = "rounded",
--   padding = { 0, 1 },
-- },
