local tobj_utils = require("mapper.utils").tobj

local function get_contained_tobjs()
  local parent_node = tobj_utils.get_parent_node()
  -- with the parent node, list all of the contained text objects and their ranges within that node

  if parent_node then
    for _, text_object in pairs(text_objects) do
      local s_row, s_col, e_row, e_col = text_object:range()
      local text = vim.treesitter.get_node_text(text_object, 0)
    end
  end
end

local setup = function(opts)
  local config = vim.tbl_deep_extend("force", config, opts)

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

  vim.api.nvim_create_user_command("TextObjs", function()
    -- show all text‑objects (i* and a*) in operator‑pending mappings
    vim.cmd([[filter /^[ai]/ verbose omap]])
    -- show all text‑objects (i* and a*) in visual‑select mappings
    vim.cmd([[filter /^[ai]/ verbose xmap]])
  end, {
    desc = "List all text‑objects (built‑in + custom)",
  })

  vim.api.nvim_create_user_command("GetParentNode", get_parent_node, { nargs = 0 })
  vim.api.nvim_create_user_command("GetParentTextObjectss", get_node_text_objects, { nargs = 0 })
end

setup({})

-- Usage: in Neovim just run
--   :TextObjs
