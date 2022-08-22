local fade_in_slide_out_stages = require("notify.stages").fade_in_slide_out
local stages_util = require("notify.stages.util")

fade_in_slide_out_stages[2] = function()
  return {
    opacity = { 100, frequency = 3 },
    col = { vim.opt.columns:get() }
  }
end

local next_col = 20
local fade_stages = {
  function(state)
    local next_height = state.message.height + 2
    local next_row = stages_util.available_slot(
      state.open_windows,
      next_height,
      stages_util.DIRECTION.TOP_DOWN
    )
    if not next_row then
      return nil
    end
    vim.dbglog({ next_col = next_col })
    return {
      relative = "editor",
      anchor = "N",
      width = state.message.width,
      height = state.message.height,
      col = next_col,
      row = next_row,
      border = "rounded",
      style = "minimal",
      opacity = 0,
    }
  end,
  function()
    return {
      opacity = { 100 },
      col = next_col
    }
  end,
  function()
    return {
      col = next_col,
      time = true,
    }
  end,
  function()
    return {
      opacity = {
        0,
        frequency = 2,
        complete = function(cur_opacity)
          return cur_opacity <= 4
        end,
      },
      col = next_col,
    }
  end,
}

return {
  fade_in_slide_out_stages,
  fade_stages
}
