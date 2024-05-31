-- -- most of these calls need to be run in a coroutine
-- coroutine.wrap(function()

local Chrome = require('chrome-remote.chrome')
local client = Chrome.new()
  -- you can get a list of targets by going to http://localhost:9222/json/list
  -- or you can use the provided action `require('chrome-remote.actions').list()` to get
  -- a UI selection of the targets
  client:open_url('ws://localhost:9222/devtools/page/ABC')

  -- once connected you can use the `send()` method to send commands to the Chrome target
  client:send('Page.navigate', { url = 'https://github.com' })

  -- if you expect a result from your call you can capture the return
  local err, result = client:send('DOM.getDocument', { depth = 0 })

  -- you can also use the following shortcut for the same call
  -- (don't forget to use colon to keep the `self` reference)
  local err, result = client.DOM:getDocument({ depth = 0 })

  -- to listen to events you can do the following
  client.Network:requestWillBeSent(function(err, params)
    -- check for err, then do something with params
  end)

  -- all commands and events are mapped to client.<domain>.<method>
  -- you can find them all available at https://chromedevtools.github.io/devtools-protocol/tot/
  -- or locally at http://localhost:9222/json/protocol

  -- close the connection
  client:close()
end)()-- most of these calls need to be run in a coroutine

-- Lists the targets on the Chrome instance, then execute the callback when a choice is made
require('chrome-remote.actions').list({}, function(err, target)
  -- example of using the target selected
  client:open_url(target.webSocketDebuggerUrl)
end)

-- Creates a new target (tab) on the Chrome instance, then executes the callback with the created target
require('chrome-remote.actions').new({}, function(err, target)
  -- example of using the target selected
  client:open_url(target.webSocketDebuggerUrl)
end)
