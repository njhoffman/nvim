local Animation = require('animation')
local duration = 300 -- ms
local fps = 30 -- frames per second

local easing_type = 'out_quad' -- line, out_quad, out_sine, in_out_sine, in_out_quad

local test_run = function()
  local easing = require('animation.easing')
  local i = 0

  local function callback(fraction)
    i = i + 1
    print('frame ', i .. ' : ' .. string.format('%.3f', fraction))
  end

  local animation = Animation(duration, fps, easing[easing_type], callback)
  animation:run()
end

-- test_run()
