
local conf_utils = {}

conf_utils.init = function(opts)
  local defaults = { modes = { "o", "x" }, strategy = { mode = false, a = true, i = true } }
  return vim.tbl_deep_extend("force", defaults, opts)
  conf_utils.get = function() return config end
end


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

--       print(
--         string.format(
--           "Text object name: %s at [%d, %d] to [%d, %d]",
--           text,
--           s_row + 1,
--           s_col + 1,
--           e_row + 1,
--           e_col + 1
--         )
--       )
local ts_utils = {}
ts_utils.get_parent_node = function()
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


ts_utils.objs_by_modes = function()
  local shared_funcs = require("nvim-treesitter.textobjects.shared")

  -- 1) collect all text‑object mappings (modes 'o' and 'x', lhs = i* or a*)
  local function custom_text_objects()
    local custom = {}
    for _, mode in ipairs({ "o", "x" }) do
      for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
        if map.lhs:match("^[ai]") then
          -- stash the mode and lhs so we can replay it later
          custom[#custom + 1] = { lhs = map.lhs, mode = mode, name = map.rhs, desc = map.desc }
        end
      end
    end
    return custom
  end
  local text_objects = shared_funcs.available_textobjects("lua", "textobjects")
  local custom_objects = custom_text_objectss()
  return text_objects, custom_objects
end

ts_utils.get_text_objects = function()
  -- nvim-treesitter.shared         available_textobjects        get_adjacent
  -- get_query_strings_from_regex   make_query_strings_table     next_textobject
  -- node_contains                  previous_textobject          textobject_at_point

  local textobjs = {}
  tobjs.directives = require("nvim-treesitter.textobjects.shared").available_textobjects('lua', 'textobjects')

  function get_by_mode()
    -- 1) collect all text‑object mappings (modes 'o' and 'x', lhs = i* or a*)
    local custom = {}
    for _, mode in ipairs(config.modes) do
      for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
        if map.lhs:match("^[ai]") then
          -- stash the mode and lhs so we can replay it later
          custom[#custom + 1] = { lhs = map.lhs, mode = mode }
        end
      end
    end

   tobjs.

    return custom
  end




  local text_objects = shared_funcs.available_textobjects("lua", "textobjects")
  local custom_objects = custom_text_objectss()
end
