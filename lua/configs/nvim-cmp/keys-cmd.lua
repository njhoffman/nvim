local cmp_types = require('cmp.types.cmp')
local cmp = require('cmp')
local keymap = require('cmp.utils.keymap')
local preserve_mapping_verticality = false

local function get_source_code(f)
  local t = debug.getinfo(f)
  if t.linedefined < 0 then
    print('source', t.source)
    return
  end
  local name = t.source:gsub('^@', '')
  local i = 0
  local text = {}
  for line in io.lines(name) do
    i = i + 1
    if i >= t.linedefined then
      text[#text + 1] = line
    end
    if i >= t.lastlinedefined then
      break
    end
  end
  return table.concat(text, '\n')
end
local feedkeys = require('cmp.utils.feedkeys')

local send_enter = function()
  local enter_key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  vim.api.nvim_feedkeys(enter_key, 'n', false)
end
local has_chars_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('.%+') == nil
end

local has_chars_after = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col + 1, col + 1):match('.%+') == nil
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local in_history = true
local cmdline = {
  ['<Tab>'] = {
    c = function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end,
  },
  ['<S-Tab>'] = {
    c = function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end,
  },
  ['<C-e>'] = {
    c = function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end,
  },
  ['<C-y>'] = {
    c = function()
      if cmp.visible() then
        cmp.confirm({ select = false })
      else
        cmp.complete()
      end
    end,
  },
  -- ['<C-n>'] = {
  --   c = function()
  --     if cmp.visible() then
  --       cmp.select_next_item({
  --         preserve_mapping_verticality = preserve_mapping_verticality,
  --         count = 1,
  --         behavior = cmp.SelectBehavior.Select,
  --       })
  --       in_history = false
  --     -- elseif in_history == true then
  --     --   feedkeys.call(keymap.t('<Down>'), 'c')
  --     else
  --       cmp.complete()
  --       -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
  --     end
  --   end,
  -- },
  -- ['<C-p>'] = {
  --   c = function()
  --     if cmp.visible() then
  --       -- if in_history and (has_chars_before() or has_chars_after()) then
  --       in_history = false
  --       -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
  --       cmp.select_prev_item({
  --         preserve_mapping_verticality = preserve_mapping_verticality,
  --         count = 1,
  --         behavior = cmp.SelectBehavior.Select,
  --       })
  --       -- else
  --       --   feedkeys.call(keymap.t('<Up>'), 'c')
  --     else
  --       cmp.complete()
  --     end
  --   end,
  -- },
  ['<C-F>'] = {
    c = function()
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          })(nil)
        end
      else
        cmp.complete()
      end
    end,
  },
  ['<C-B>'] = {
    c = function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do
          cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          })(nil)
        end
      else
        cmp.complete()
      end
    end,
  },
}
return cmdline
-- local cmdline = {
--   ["<M-'>"] = {
--     c = function(fallback)
--       if cmp.visible() then
--         cmp.confirm({
--           behavior = cmp.ConfirmBehavior.Replace,
--           select = true,
--         })
--       elseif type(fallback) == 'function' then
--         fallback()
--       end
--     end,
--   },
--   ['<C-z>'] = {
--     c = function()
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         cmp.complete()
--       end
--     end,
--   },
--   ['<Tab>'] = {
--     c = function()
--       if cmp.visible() then
--         cmp.select_next_item()
--       else
--         cmp.complete()
--       end
--     end,
--   },
--   ['<S-Tab>'] = {
--     c = function()
--       if cmp.visible() then
--         cmp.select_prev_item()
--       else
--         cmp.complete()
--       end
--     end,
--   },
--   ['<C-n>'] = {
--     c = function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item({
--           preserve_mapping_verticality = preserve_mapping_verticality,
--           count = 1,
--           behavior = cmp.SelectBehavior.Select,
--         })
--       elseif type(fallback) == 'function' then
--         fallback()
--       else
--         cmp.complete()
--       end
--     end,
--   },
--   ['<C-p>'] = {
--     c = function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item({
--           preserve_mapping_verticality = preserve_mapping_verticality,
--           count = 1,
--           behavior = cmp.SelectBehavior.Select,
--         })
--       elseif type(fallback) == 'function' then
--         fallback()
--       else
--         cmp.complete()
--       end
--     end,
--   },
--   ['<C-e>'] = { c = cmp.mapping.abort() },
--   ['<C-y>'] = { c = cmp.mapping.confirm({ select = false }) },
-- }
-- --   ['<C-p>'] = {
-- --     c = function(fallback)
-- --       if cmp.visible() then
-- --         if in_history and has_chars_before() then
-- --           in_history = false
-- --           cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
-- --         elseif in_history then
-- --           feedkeys.call(keymap.t('<Up>'), 'c')
-- --         else
-- --           cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
-- --           -- cmp.select_prev_item()
-- --         end
-- --       elseif type(fallback) == 'function' then
-- --         fallback()
-- --       else
-- --         cmp.complete()
-- --       end
-- --     end,
-- --   },
-- --   ['<C-n>'] = {
-- --     c = function(fallback)
-- --       if cmp.visible() then
-- --         cmp.select_next_item({
-- --           preserve_mapping_verticality = preserve_mapping_verticality,
-- --           count = 1,
-- --           behavior = cmp.SelectBehavior.Select,
-- --         })
-- --       elseif type(fallback) == 'function' then
-- --         fallback()
-- --       else
-- --         cmp.complete()
-- --       end
-- --     end,
-- --   },
-- --   -- cmp.select_next_item({
-- --   --   preserve_mapping_verticality = preserve_mapping_verticality,
-- --   --   count = 1,
-- --   --   behavior = cmp.SelectBehavior.Select,
-- --   -- })
-- --   -- elseif in_history == true then
-- --   --   feedkeys.call(keymap.t('<Down>'), 'c')
-- --   --   -- cmp.mapping.complete({ config = { sources = { { name = "cmdline_history" } } } })
-- --   --   -- cmp.complete()
-- --   -- elseif has_chars_before() or not in_history then
-- --   --   in_history = false
-- --   --   -- cmp.complete()
-- --   --   cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
-- --   -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
-- --   -- ['<C-p>'] = {
-- --   --   c = function(fallback)
-- --   --     if cmp.visible() and cmp.get_selected_entry() then
-- --   --       cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
-- --   --     elseif in_history == true then
-- --   --       -- cmp.mapping.complete({ config = { sources = { { name = 'cmdline_history' } } } })
-- --   --       feedkeys.call(keymap.t('<Up>'), 'c')
-- --   --     -- elseif type(fallback) == 'function' then
-- --   --     --   fallback()
-- --   --     else
-- --   --       cmp.complete()
-- --   --     end
-- --   --   end,
-- --   -- },
-- --   ['<C-f>'] = {
-- --     c = function(fallback)
-- --       if cmp.visible() then
-- --         for _ = 1, 5 do
-- --           cmp.mapping.select_next_item({
-- --             behavior = cmp_types.SelectBehavior.Select,
-- --           })(nil)
-- --         end
-- --       elseif type(fallback) == 'function' then
-- --         fallback()
-- --       end
-- --     end,
-- --   },
-- --   ['<C-b>'] = {
-- --     c = function(fallback)
-- --       if cmp.visible() then
-- --         for _ = 1, 5 do
-- --           cmp.mapping.select_prev_item({
-- --             behavior = cmp_types.SelectBehavior.Select,
-- --           })(nil)
-- --         end
-- --       elseif type(fallback) == 'function' then
-- --         fallback()
-- --       end
-- --     end,
-- --   },
-- -- }
--
