local print_out = function(title, item)
  local logger = require("logger.debug.parsers.inspect")
  print(logger.inspect({ title, result }))
end

-- most of these calls need to be run in a coroutine
local start = function(url)
  local Chrome = require("chrome-remote.chrome")
  local client = Chrome.new()

  print_out("url: " .. url, res)
  local res = client:open_url(url)
  print_out("url: " .. url, res)

  res = client:send("Page.navigate", { url = "https://github.com" })
  print_out({ "nav 1:: github.com", res })

  res = client:send("DOM.getDocument", { depth = 0 })
  print_out({ "get_doc: DOM.getDocument", res })

  -- you can also use the following shortcut for the same call
  -- (don't forget to use colon to keep the `self` reference)
  -- local err, result = client.DOM:getDocument({ depth = 0 })

  -- to listen to events you can do the following
  client.Network:requestWillBeSent(function(err, params)
    -- check for err, then do something with params
    print_out({ "listener: ", params, err })
  end)

  -- all commands and events are mapped to client.<domain>.<method>
  -- you can find them all available at https://chromedevtools.github.io/devtools-protocol/tot/
  -- or locally at http://localhost:9222/json/protocol

  -- close the connection
  client:close()
end

require("chrome-remote.actions").list(nil, function(err, choice)
  vim.dbglog("CHOICE", choice)
  coroutine.wrap(start)(choice.webSocketDebuggerUrl)
end)
