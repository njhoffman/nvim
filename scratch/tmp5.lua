local get_active_window = function() end
local get_active_buffer = function() end
local get_windows = function() end

local get_extmarks = function(opts)
  opts = opts or {}
  local nsn = vim.api.nvim_get_namespaces()

  local leaked_count = 0
  for name, ns in pairs(nsn) do
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      leaked_count = leaked_count + #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
    end
  end
  return leaked_count
  --   [extmark_id, row, col]
  -- local nsn = vim.api.nvim_get_namespaces()
  -- local count = 0
  -- for name, ns in pairs(nsn) do
  --   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  --     local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {
  --       -- type = 'highlight', -- highlight, sign, virt_text, virt_lines
  --       details = true,
  --       hl_name = true,
  --     })
  --     -- extmarks[1][4] = { end_col = 68, end_right_gravity = false, end_row = 4, hl_eol = false, hl_group = "MatchParen", ns_id = 15, priority = 4096, right_gravity = true }
  --     -- extmarks[1][4].virtual_text = { [1] = { [1] = "", [2] = "ActionHintsDefinition" }, [2] = { [1] = "", [2] = "ActionHintsReferences" }, [3] = { [1] = " 9", [2] = "ActionHintsCodeActions" } }, virt_text_hide = false, virt_text_pos = "eol"virt_text = { [1] = { [1] = " ", [2] = "ScrollbarHandle" } }, virt_text_hide = false, virt_text_pos = "right_align" }
  --   end
  -- end
end

-- Total Namespaces-Extmarks-Leaked       ***     ***      ***
--   ~/.config/nvim/scratch/tmp5.lua      ***     ***      ***
--   ~/.config/nvim/scratch/tmp0.lua      ***     ***      ***
--   38      BaleiaColors
--           20   ~/.config/nvim/scratch/tmp0.lua
--               3:4,6:13       NotifyDEBUGBody2219
--               8:0,9:0        NoiceAttr257
--           10   ~/.config/nvim/scratch/tmp1.lua
--               3:4,6:13       NotifyDEBUGBody2219
--               8:0,9:0        NoiceAttr257
--   50      Glance
--   24      Luasnip
--   87      MiniAiInput
--   91      MiniAlignInput
--   86      MiniAnimateCursor
--   22      MiniFilesHighlight
--   55      MiniIndentscope
--   23      MiniOperatorsExchange
--   90      MiniSplitjoin
--   93      MiniSurroundHighlight
--   94      MiniSurroundInput
--   730     Scrollbar
--   923     SidebarNvimHighlights
--   66      SmoothCursor
--   71      SmoothCursorAqua
--   72      SmoothCursorBlue
--   70      SmoothCursorGreen
--   68      SmoothCursorOrange
--   73      SmoothCursorPurple
--   67      SmoothCursorRed
--   69      SmoothCursorYellow
--   15      TSPlaygroundHlGroups
--   16      TSPlaygroundLangGroups
--   35      WhichKey
--   711     ["aerial-line"]
--   53      ["cmp.plugin"]
--   46      ["cmp.view.custom_entries_view"]
