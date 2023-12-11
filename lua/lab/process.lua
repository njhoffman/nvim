local Job = require('plenary.job')
local Util = require('lab.util')
local logger = require('logger').init('lab')

local process = {
  running = false,
  instance = nil,
  handlers = {},
}

local function script_path()
  local src = debug.getinfo(2, 'S').source:sub(2)
  return src:match('(.*/)')
end

function process:register(handler)
  table.insert(self.handlers, handler)
  return function()
    table.remove(self.handlers, Util.tablefind(self.handlers, handler))
  end
end

function process:start()
  if self.running then
    logger:debug('process already started')
    return
  end
  local args = { script_path() .. '../../bin/runner/dist/index.js' }
  logger:debug('starting a new job: ' .. vim.inspect(args))
  self.instance = Job:new({
    command = 'node',
    args = args,
    on_stdout = function(error, data)
      logger:trace('stdout= ' .. vim.inspect(error) .. vim.inspect(data))
      local success, msg = pcall(function()
        return vim.json.decode(data)
      end)

      if not success then
        return
      end

      for key, handler in pairs(self.handlers) do
        handler(msg)
      end
    end,

    on_stderr = function(error, data)
      logger:debug('stderr= ' .. vim.inspect(error) .. vim.inspect(data))
    end,
  })
  self.instance:start()
  self.running = true
end

function process:send(data)
  logger:debug('attempting to send data: ' .. vim.inspect(data))
  if not process.running then
    return
  end
  local success, payload = pcall(function()
    logger:trace('process send successful')
    return vim.json.encode(data)
  end)
  if not success then
    logger:debug('process send failed: ' .. vim.inspect(payload))
    return
  end
  process.instance:send(payload .. '\n')
end

function process:stop()
  if process.running then
    vim.schedule_wrap(function()
      vim.loop.kill(self.instance.pid, 3)
      self.running = false
      self.instance = nil
    end)
  end
end

return process
