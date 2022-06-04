-- f{char}/F, t{char}/T enhancement
local luasnip = require("luasnip")

require("tabout").setup({
  tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
  backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
  act_as_tab = false, -- shift content if tab out is not possible
  act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
  default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
  default_shift_tab = '<C-d>', -- reverse shift default action,
  enable_backwards = true, -- well ...
  completion = true, -- if the tabkey is used in a completion pum
  tabouts = {
    { open = "'", close = "'" },
    { open = '"', close = '"' },
    { open = '`', close = '`' },
    { open = '(', close = ')' },
    { open = '[', close = ']' },
    { open = '{', close = '}' }
  },
  ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
  exclude = {} -- tabout will ignore these filetypes
})

-- TODO: integrate normal mode mapping
-- TODO: if no tabout motion, move word forward/backwards

-- local function nvim_compe_config()
--   require("tabout").setup(
--     {
--       tabkey = "",
--       backwards_tabkey = "",
--       act_as_tab = false, -- shift content if tab out is not possible
--       act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
--       ignore_beginning = true
--     }
--   )

--   local function replace_keycodes(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
--   end

--   function _G.tab_binding()
--     if vim.fn.pumvisible() ~= 0 then
--       return replace_keycodes("<C-n>")
--     elseif luasnip.expand_or_jumpable() then
--       luasnip.expand_or_jump()
--     else
--       return replace_keycodes("<Plug>(TaboutMulti)")
--     end
--   end

--   function _G.s_tab_binding()
--     if vim.fn.pumvisible() ~= 0 then
--       return replace_keycodes("<C-p>")
--     elseif luasnip.jumpable(-1) then
--       luasnip.jump(-1)
--     else
--       return replace_keycodes("<Plug>(TaboutBackMulti)")
--     end
--   end

--   -- vim.api.nvim_set_keymap("n", "<Tab>", "<Plug>(TaboutMulti)", { expr = false })
--   -- vim.api.nvim_set_keymap("n", "<S-Tab>", "<Plug>(TaboutBackMulti)", { expr = false })
--   vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_binding()", { expr = true })
--   vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_binding()", { expr = true })
-- end

-- if H.is_module_available("tabout") then nvim_compe_config() end
