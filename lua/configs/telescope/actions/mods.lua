local actions = require('telescope.actions')

local gen_map_funcs = function(maps, opts)
  local newmaps = {}
  for key, action in pairs(maps) do
    if type(action) == 'function' then
      newmaps[key] = function(prompt_bufnr)
        return action(prompt_bufnr, opts)
      end
    elseif type(action) == 'string' then
      newmaps[key] = actions[action]
    elseif type(action) == 'table' then
      local map_table = {}
      for i, _action in ipairs(action) do
        if type(_action) == 'function' then
          map_table[i] = function(prompt_bufnr)
            return _action(prompt_bufnr, opts)
          end
        elseif type(action) == 'string' then
          map_table = actions[_action]
        end
      end
      newmaps[key] = map_table
    end
  end
  return newmaps
end

local yank_mods = {
  highlights = function(lines)
    return lines
  end,
}

return {
  gen_map_funcs = gen_map_funcs,
  yanks = yank_mods,
}
