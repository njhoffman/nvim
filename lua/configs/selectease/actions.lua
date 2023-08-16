local select_ease = require('SelectEase')
local lang = require('configs.selectease.queries')

local queries = {
  go = lang.go_query,
  lua = lang.lua_query,
  python = lang.python_query,
  tsx = lang.tsx_query,
}

local actions = {}

actions.select_node_left = function()
  select_ease.select_node({
    queries = queries,
    direction = 'previous',
  })
end

actions.select_node_right = function()
  select_ease.select_node({
    queries = queries,
    direction = 'next',
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end
actions.select_node_up = function()
  select_ease.select_node({
    queries = queries,
    direction = 'previous',
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
    -- fallback = function()
    --   -- if there's no target, this function will be called
    --   select_ease.select_node({ queries = queries, direction = 'previous' })
    -- end,
  })
end
actions.select_node_down = function()
  select_ease.select_node({
    queries = queries,
    direction = 'next',
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end

actions.swap_nodes_left = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = 'previous',
  })
end
actions.swap_nodes_right = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = 'next',
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end
actions.swap_nodes_up = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = 'previous',
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
    -- fallback = function()
    --   -- if there's no target, this function will be called
    --   select_ease.swap_nodes({ queries = queries, direction = 'previous' })
    -- end,
  })
end
actions.swap_nodes_down = function()
  select_ease.swap_nodes({
    queries = queries,
    direction = 'next',
    vertical_drill_jump = true,
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
  })
end

-- select_ease.select_node({
--                queries = queries,
--                direction = "previous",
--                vertical_drill_jump = true,
--                -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
--                fallback = function()
--                    -- if there's no target, this function will be called
--                    select_ease.select_node({ queries = queries, direction = "previous" })
--                end,
--            })

return actions
