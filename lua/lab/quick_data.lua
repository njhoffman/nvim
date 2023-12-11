local process = require('lab.process')
local quick_data_comp = require('lab.quick_data_cmp')
local cmp = require('cmp')

local quick_data = {
  handlers = {},
}

process:register(function(msg)
  if not msg.method then
    if quick_data.handlers[msg.id] then
      quick_data.handlers[msg.id](msg.result)
      quick_data.handlers[msg.id] = nil
    end
  end
end)

function quick_data.init()
  local id = 'quickdata.init'
  cmp.register_source('faker.quick_data', quick_data_comp.new())
  local initHandler = function(data)
    quick_data_comp.init(data.path, quick_data.update)
  end
  quick_data.handlers[id] = initHandler
  process:send({
    jsonrpc = '2.0',
    id = id,
    method = 'Lab.Config.Get',
    params = {
      key = 'quick.data.source',
    },
  })
end

function quick_data.update(index, mod, method, updateFunc)
  local id = 'quickdata.update.' .. tostring(index)
  quick_data.handlers[id] = updateFunc
  process:send({
    jsonrpc = '2.0',
    id = id,
    method = 'Lab.quick_data.Update',
    params = {
      mod = mod,
      method = method,
    },
  })
end

return quick_data
