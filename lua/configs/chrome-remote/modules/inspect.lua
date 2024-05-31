local Chrome = require('chrome-remote.chrome')

-- {
--   description = "",
--   devtoolsFrontendUrl = "/devtools/inspector.html?ws=localhost:9222/devtools/page/CE122263A70AD683B6A9D775E7AF1460",
--   webSocketDebuggerUrl = "ws://localhost:9222/devtools/page/CE122263A70AD683B6A9D775E7AF1460"
--   faviconUrl = "https://github.githubassets.com/favicons/favicon-dark.svg",
--   title = "unimpaired.nvim/lua/unimpaired/config.lua at main · tummetott/unimpaired.nvim",
--   type = "page",
--   id = "CE122263A70AD683B6A9D775E7AF1460",
--   url = "https://github.com/tummetott/unimpaired.nvim/blob/main/lua/unimpaired/config.lua#L14",
-- }
-- .list(nil, function(err, choice)
--   coroutine.wrap(start)(choice.webSocketDebuggerUrl)
-- end)

local inspect = function(client, target, event)
  local url = target.devtoolsFrontendUrl

  -- example of using the target selected
  client:open_url(target.webSocketDebuggerUrl)
  if err then
    print('error', vim.inspect(err))
  else
    vim.dbglog('open succesful')
    coroutine.wrap(start)(url)
  end
end

local inspect_tabs = function(ev)
  local client = Chrome.new()
  vim.dbglog('client', client)
  require('chrome-remote.actions').list({}, function(err, target)
    if err then
      vim.dbglog('ERR', err)
    else
      return inspect(client, target, event)
    end
  end)
end

return inspect_tabs
