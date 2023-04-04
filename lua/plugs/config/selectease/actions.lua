local select_ease = require("SelectEase")

-- For more language support check the `Queries` section
local lua_query = [[
    ;; query
    ((identifier) @cap)
    ("string_content" @cap)
    ((true) @cap)
    ((false) @cap)
]]
local python_query = [[
      ;; query
      ((identifier) @cap)
      ((string) @cap)
  ]]

local queries = {
  lua = lua_query,
  python = python_query,
}
local actions = {}

actions.swap_nodes_left = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = "previous",
  })
end
actions.swap_nodes_right = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = "next",
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end
actions.swap_nodes_up = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = "previous",
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
    fallback = function()
      -- if there's no target, this function will be called
      select_ease.swap_nodes({ queries = queries, direction = "previous" })
    end,
  })
end
actions.swap_nodes_down = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = "next",
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end

actions.select_node_left = function()
  select_ease.select_node({
    queries = queries,
    direction = "previous",
  })
end
actions.select_node_right = function()
  select_ease.select_node({
    queries = queries,
    direction = "next",
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end
actions.select_node_up = function()
  select_ease.select_node({
    queries = queries,
    direction = "previous",
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
    fallback = function()
      -- if there's no target, this function will be called
      select_ease.select_node({ queries = queries, direction = "previous" })
    end,
  })
end
actions.select_node_down = function()
  select_ease.select_node({
    queries = queries,
    direction = "next",
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end

return actions
