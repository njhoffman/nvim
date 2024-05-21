local select_ease = require('SelectEase')
local swap_nodes = require('configs.selectease.swap_nodes')
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
    -- visual_mode = true, -- if you want Visual Mode instead of Select Mode
    queries = queries,
    direction = 'previous',
  })
end

actions.select_node_right = function()
  select_ease.select_node({
    queries = queries,
    direction = 'next',
  })
end

actions.select_node_up = function()
  select_ease.select_node({
    queries = queries,
    direction = 'previous',
    vertical_drill_jump = true,
    fallback = function()
      select_ease.select_node({ queries = queries, direction = 'previous' })
    end,
  })
end

actions.select_node_down = function()
  select_ease.select_node({
    queries = queries,
    direction = 'next',
    vertical_drill_jump = true,
    fallback = function()
      select_ease.select_node({ queries = queries, direction = 'next' })
    end,
  })
end

actions.swap_nodes_left = function()
  swap_nodes({
    queries = queries,
    direction = 'previous',
  })
end

actions.swap_nodes_right = function()
  swap_nodes({
    queries = queries,
    direction = 'next',
  })
end

actions.swap_nodes_up = function()
  swap_nodes({
    queries = queries,
    direction = 'previous',
    vertical_drill_jump = true,
  })
end

actions.swap_nodes_down = function()
  swap_nodes({
    queries = queries,
    direction = 'next',
    vertical_drill_jump = true,
  })
end

return actions
