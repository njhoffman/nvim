local Chrome = require('chrome-remote.chrome')

local inspect_cb = function(err, target)
  if err then
    vim.dbglog('ERR', err)
  else
    -- example of using the target selected
    -- vim.inspect(target)
    vim.dbglog(target)
    client:open_url(target.webSocketDebuggerUrl)
  end

  local url = target
  local err = client:open_url(url)
  if err then
    print(vim.inspect(err))
  end
end

local inspect_tabs = function(ev)
  local client = Chrome.new()
  vim.dbglog('client', client)
  require('chrome-remote.actions').list({}, inspect_cb)
end
