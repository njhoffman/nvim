-- local Range = require("u.range")
-- Range.from_motion("iu")

-- vim.keymap.set("n", "<F8>", function()
--   vim.dbglog("INSIDE")
--   vim.dbglog(Range.from_motion("iB"))
-- end, { noremap = true, nowait = true })

-- vim.keymap.set("n", "<F9>", function()
--   vim.dbglog("INSIDE2")
--   vim.dbglog(Range.from_motion("$"))
-- end, { noremap = true, nowait = true })

local function get_parent_node()
  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1] - 1, cursor_pos[2]

  -- Get the parser for the current buffer
  local parser = vim.treesitter.get_parser(bufnr)
  local tree = parser:parse()[1]

  -- Get the root node of the syntax tree
  local root = tree:root()

  local parent_node = root:named_descendant_for_range(row, col, row, col)
  -- local parent_node = node:parent()
  if not parent_node then
    print("No parent node found")
    -- Get the start and end position of the parent node
    -- local s_row, s_col, e_row, e_col = parent_node:range()
    -- vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
  end
  return parent_node
end

local get_text_objects = function()
  local shared_funcs = require("nvim-treesitter.textobjects.shared")

  -- 1) collect all text‑object mappings (modes 'o' and 'x', lhs = i* or a*)
  local function custom_text_objectss()
    local custom = {}
    for _, mode in ipairs({ "o", "x" }) do
      for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
        if map.lhs:match("^[ai]") then
          -- stash the mode and lhs so we can replay it later
          custom[#custom + 1] = { lhs = map.lhs, mode = mode }
        end
      end
    end
    return custom
  end
  local text_objects = shared_funcs.available_textobjects("lua", "textobjects")
  local custom_objects = custom_text_objectss()
end

vim.api.nvim_create_user_command("TextObjs", function()
  -- show all text‑objects (i* and a*) in operator‑pending mappings
  vim.cmd([[filter /^[ai]/ verbose omap]])
  -- show all text‑objects (i* and a*) in visual‑select mappings
  vim.cmd([[filter /^[ai]/ verbose xmap]])
end, {
  desc = "List all text‑objects (built‑in + custom)",
})

-- Usage: in Neovim just run
--   :TextObjs

local function get_node_text_objects()
  local parent_node = get_parent_node()
  -- with the parent node, list all of the contained text objects and their ranges within that node

  vim.dbglog("parent node: " .. parent_node:type() .. " - " .. parent_node:range())

  -- available_textobjects = '<function 1>',
  -- get_adjacent = '<function 2>',
  -- get_query_strings_from_regex = '<function 3>',
  -- make_query_strings_table = '<function 4>',
  -- next_textobject = '<function 5>',
  -- node_contains = '<function 6>',
  -- previous_textobject = '<function 7>',
  -- textobject_at_point = '<function 8>'

  if parent_node then
    for _, text_object in pairs(text_objects) do
      local s_row, s_col, e_row, e_col = text_object:range()
      local text = vim.treesitter.get_node_text(text_object, 0)
      print(
        string.format(
          "Text object name: %s at [%d, %d] to [%d, %d]",
          text,
          s_row + 1,
          s_col + 1,
          e_row + 1,
          e_col + 1
        )
      )
    end
  end

  -- local child_nodes = parent_node:named_children()
  -- for _, child_node in pairs(child_nodes) do
  --   local s_row, s_col, e_row, e_col = child_node:range()
  --   -- Get the textobjects

  --   -- vim.treesitter.query.get_node_text(child_node, 0),
  --   print(
  --     string.format(
  --       "Text object name: %s at [%d, %d] to [%d, %d]",
  --       s_row + 1,
  --       s_col + 1,
  --       e_row + 1,
  --       e_col + 1
  --     )
  --   )
  -- end
end

vim.api.nvim_create_user_command("GetParentNode", get_parent_node, { nargs = 0 })
vim.api.nvim_create_user_command("GetParentTextObjectss", get_node_text_objects, { nargs = 0 })

-- ### Basic Text Objects in Normal Mode
-- Neovim defines several text objects, which are generally accessed using the commands `vi<object>` (to visually select the text object) and `di<object>` (to delete the text object around the cursor). The object can be:

-- - `w` for word
-- - `s` for a sentence
-- - `p` for a paragraph
-- - `[` or `]` for a section/block (in applicable programming contexts)
-- - `'`, `"`, `(`, `{`, etc., for content within quotes, parentheses, or braces.

--  {                                  --  {
--    "block.inner",                   --    {lhs = "aN", mode = "o" },                  { lhs = "aN", mode = "x" },
--    "block.outer",                   --    { lhs = "an", mode = "o" },                 { lhs = "an", mode = "x" },
--    "call.outer",                    --    { lhs = "a", mode = "o" },                  { lhs = "a", mode = "x" },
--    "call.inner",                    --    { lhs = "a#", mode = "o" },                 { lhs = "a#", mode = "x" },
--    "_start",                        --    { lhs = "aF", mode = "o" },                 { lhs = "aF", mode = "x" },
--    "_end",                          --    { lhs = "am", mode = "o" },                 { lhs = "am", mode = "x" },
--    "comment.inner",                 --    { lhs = "ak", mode = "o" },                 { lhs = "ak", mode = "x" },
--    "comment.outer",                 --    { lhs = "av", mode = "o" },                 { lhs = "av", mode = "x" },
--    "conditional.inner",             --    { lhs = "a,", mode = "o" },                 { lhs = "a,", mode = "x" },
--    "conditional.outer",             --    { lhs = "az", mode = "o" },                 { lhs = "az", mode = "x" },
--    "function.outer",                --    { lhs = "a_", mode = "o" },                 { lhs = "a_", mode = "x" },
--    "function.inner",                --    { lhs = "a%", mode = "o" },                 { lhs = "a%", mode = "x" },
--    "return.inner",                  --    { lhs = "au", mode = "o" },                 { lhs = "au", mode = "x" },
--    "return.outer",                  --    { lhs = "ih", mode = "o" },                 { lhs = "ih", mode = "x" },
--    "loop.outer",                    --    { lhs = "iN", mode = "o" },                 { lhs = "iN", mode = "x" },
--    "loop.inner",                    --    { lhs = "in", mode = "o" },                 { lhs = "in", mode = "x" },
--    "parameter.inner",               --    { lhs = "i", mode = "o" },                  { lhs = "i", mode = "x" },
--    "number.inner",                  --    { lhs = "i#", mode = "o" },                 { lhs = "i#", mode = "x" },
--    "assignment.lhs",                --    { lhs = "iF", mode = "o" },                 { lhs = "iF", mode = "x" },
--    "assignment.inner",              --    { lhs = "im", mode = "o" },                 { lhs = "im", mode = "x" },
--    "assignment.rhs",                --    { lhs = "ik", mode = "o" },                 { lhs = "ik", mode = "x" },
--    "assignment.outer",              --    { lhs = "iv", mode = "o" },                 { lhs = "iv", mode = "x" },
--    "statement.outer",               --    { lhs = "i,", mode = "o" },                 { lhs = "i,", mode = "x" },
--    "parameter.outer",               --    { lhs = "iz", mode = "o" },                 { lhs = "iz", mode = "x" },
--  }                                  --    { lhs = "i_", mode = "o" },                 { lhs = "i_", mode = "x" },
--                                     --    { lhs = "i%", mode = "o" },                 { lhs = "i%", mode = "x" },
--                                     --    { lhs = "iu", mode = "o" },                 { lhs = "iu", mode = "x"},
--                                     --  }
--                                     --
-- { {
--     desc = "î­¾  around prev textobject",
--     lhs = "aN",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "î­¾  around next textobject",
--     lhs = "an",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "Around textobject",
--     lhs = "a",
--     mode = "o"
--   }, {
--     desc = "outer chainMember textobj",
--     lhs = "am",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').chainMember('outer')<CR>"
--   }, {
--     desc = "î­¾  around key from kv pair",
--     lhs = "ak",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').key('outer')<CR>"
--   }, {
--     desc = "î­¾  around underscore",
--     lhs = "a_",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "outer closedFold textobj",
--     lhs = "az",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').closedFold('outer')<CR>"
--   }, {
--     desc = "î­¾  around value from kv pair",
--     lhs = "av",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').value('outer')<CR>"
--   }, {
--     desc = "outer filepath textobj",
--     lhs = "aF",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').filepath('outer')<CR>"
--   }, {
--     desc = "outer color textobj",
--     lhs = "a#",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').color('outer')<CR>"
--   }, {
--     desc = "outer argument textobj",
--     lhs = "a,",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').argument('outer')<CR>"
--   }, {
--     desc = "ï£¯ Select an |any-block| like built-in |ab|",
--     lhs = "a%",
--     mode = "o",
--     name = "<Plug>(matchup-a%)"
--   }, {
--     lhs = "au",
--     mode = "o",
--     name = ':<C-U>lua require("treesitter._textobjects.unit").select(true)<CR>'
--   }, {
--     desc = "Select Hunk textobject",
--     lhs = "ih",
--     mode = "o"
--   }, {
--     desc = "î­¾  inside prev textobject",
--     lhs = "iN",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "î­¾  inside next textobject",
--     lhs = "in",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "Inside textobject",
--     lhs = "i",
--     mode = "o"
--   }, {
--     desc = "inner chainMember textobj",
--     lhs = "im",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').chainMember('inner')<CR>"
--   }, {
--     desc = "î­¾  inner key from kv pair",
--     lhs = "ik",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').key('inner')<CR>"
--   }, {
--     desc = "î­¾  inner underscore",
--     lhs = "i_",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "inner closedFold textobj",
--     lhs = "iz",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').closedFold('inner')<CR>"
--   }, {
--     desc = "î­¾  inner value from kv pair",
--     lhs = "iv",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').value('inner')<CR>"
--   }, {
--     desc = "inner filepath textobj",
--     lhs = "iF",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').filepath('inner')<CR>"
--   }, {
--     desc = "inner color textobj",
--     lhs = "i#",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').color('inner')<CR>"
--   }, {
--     desc = "inner argument textobj",
--     lhs = "i,",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').argument('inner')<CR>"
--   }, {
--     desc = "ï£¯ Select an |open-to-close-block| like built-in |ib|",
--     lhs = "i%",
--     mode = "o",
--     name = "<Plug>(matchup-i%)"
--   }, {
--     lhs = "iu",
--     mode = "o",
--     name = ':<C-U>lua require("treesitter._textobjects.unit").select()<CR>'
--   }, {
--     desc = "î­¾  around prev textobject",
--     lhs = "aN",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "î­¾  around next textobject",
--     lhs = "an",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "Around textobject",
--     lhs = "a",
--     mode = "x"
--   }, {
--     desc = "outer chainMember textobj",
--     lhs = "am",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').chainMember('outer')<CR>"
--   }, {
--     desc = "î­¾  around key from kv pair",
--     lhs = "ak",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').key('outer')<CR>"
--   }, {
--     desc = "î­¾  around underscore",
--     lhs = "a_",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "outer closedFold textobj",
--     lhs = "az",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').closedFold('outer')<CR>"
--   }, {
--     desc = "î­¾  around value from kv pair",
--     lhs = "av",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').value('outer')<CR>"
--   }, {
--     desc = "outer filepath textobj",
--     lhs = "aF",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').filepath('outer')<CR>"
--   }, {
--     desc = "outer color textobj",
--     lhs = "a#",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').color('outer')<CR>"
--   }, {
--     desc = "outer argument textobj",
--     lhs = "a,",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').argument('outer')<CR>"
--   }, {
--     desc = "ï£¯ Select an |any-block| like built-in |ab|",
--     lhs = "a%",
--     mode = "x",
--     name = "<Plug>(matchup-a%)"
--   }, {
--     lhs = "au",
--     mode = "x",
--     name = ':lua require("treesitter._textobjects.unit").select(true)<CR>'
--   }, {
--     desc = "Select Hunk textobject",
--     lhs = "ih",
--     mode = "x"
--   }, {
--     desc = "î­¾  inside prev textobject",
--     lhs = "iN",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "î­¾  inside next textobject",
--     lhs = "in",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "Inside textobject",
--     lhs = "i",
--     mode = "x"
--   }, {
--     desc = "inner chainMember textobj",
--     lhs = "im",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').chainMember('inner')<CR>"
--   }, {
--     desc = "î­¾  inner key from kv pair",
--     lhs = "ik",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').key('inner')<CR>"
--   }, {
--     desc = "î­¾  inner underscore",
--     lhs = "i_",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "inner closedFold textobj",
--     lhs = "iz",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').closedFold('inner')<CR>"
--   }, {
--     desc = "î­¾  inner value from kv pair",
--     lhs = "iv",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').value('inner')<CR>"
--   }, {
--     desc = "inner filepath textobj",
--     lhs = "iF",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').filepath('inner')<CR>"
--   }, {
--     desc = "inner color textobj",
--     lhs = "i#",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').color('inner')<CR>"
--   }, {
--     desc = "inner argument textobj",
--     lhs = "i,",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').argument('inner')<CR>"
--   }, {
--     desc = "ï£¯ Select an |open-to-close-block| like built-in |ib|",
--     lhs = "i%",
--     mode = "x",
--     name = "<Plug>(matchup-i%)"
--   }, {
--     lhs = "iu",
--     mode = "x",
--     name = ':lua require("treesitter._textobjects.unit").select()<CR>'
--   } }
