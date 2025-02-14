local animations = {}
-- local get_animation = function(id)
--   local animation = parse_animations(bufprop
--   local start_pos = table.concat({ anim.range.start_line, anim.range.start_col, }, ':')
--   local end_pos = table.concat({ anim.range.end_line, anim.range.end_col }, ':')
--   return {
--     active = anim.active,
--     range = range,
--     id = anim.id,
--     reserved = { anim.reserved_ids },
--     range = { start_pos, end_pos  }
--   }
-- end

-- animations = {
--   -- You} can add as many animations as you want
--   custom = {
--     -- You can also add as many custom options as you want
--     -- Only `max_duration` and `chars_for_max_duration` is required
--     max_duration = 350,
--     chars_for_max_duration = 40,
--
--     -- color = hl_visual_bg,
--
--     -- Custom effect function
--     -- @param self table The effect object
--     -- @param progress number The progress of the animation [0, 1]
--     --
--     -- Should return a color and a progress value
--     -- that represents how much of the animation should be drawn
--     -- self.settings represents the settings of the animation that you defined above
--     effect = function(self, progress)
--       return self.settings.color, progress
--     end,
--   },
-- },
local get_animation = function(anim)
  local start_pos = table.concat({ anim.range.start_line, anim.range.start_col }, ":")
  local end_pos = table.concat({ anim.range.end_line, anim.range.end_col }, ":")
  return {
    active = anim.active,
    id = anim.id,
    reserved = { anim.reserved_ids },
    range = { start_pos, end_pos },
  }
end

local get_buffer = function(bufnr, bufobj)
  return {
    bufnr = bufnr,
    curr = curr_buf == bufnr,
    timesi = vim.loop.now(),
    valid = vim.api.nvim_buf_is_valid(bufnr),
    loaded = vim.api.nvim_buf_is_loaded(bufnr),
    lines = vim.api.nvim_buf_line_count(bufnr),
    name = vim.api.nvim_buf_get_name(bufnr),
  }
end

local get_state = function()
  local instance = factory.get_instance()
  local state = {
    bufnr = vim.api.nvim_get_current_buf,
    buffers = {},
    animations = {},
  }

  -- for bufnr, bufobj in pairs(instance.buffers) do
  --   table.insert(list, pos, value)state.buffers, get_buffer(bufnr, bufobj)
  --   --   table.inser(
  --   -- end
  -- end
  --
end

return { get_state = get_state }
