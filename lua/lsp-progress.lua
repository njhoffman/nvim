local function mk_handler(fn)
  return function(...)
    local config_or_client_id = select(4, ...)
    local is_new = type(config_or_client_id) ~= "number"
    if is_new then
      fn(...)
    else
      local err = select(1, ...)
      local method = select(2, ...)
      local result = select(3, ...)
      local client_id = select(4, ...)
      local bufnr = select(5, ...)
      local config = select(6, ...)
      fn(err, result, { method = method, client_id = client_id, bufnr = bufnr }, config)
    end
  end
end

local clients = {}
local messages = {}

local function ensure_init(_messages, id, name)
  if not _messages[id] then
    _messages[id] = { name = name, messages = {}, progress = {}, status = {} }
  end
end
local last_redraw = nil
local timer_going = false

local function redraw_callback(now)
  last_redraw = now or vim.loop.now()
  vim.api.nvim_command("redrawstatus!")
  timer_going = false
end

local wrapped_redraw_callback = vim.schedule_wrap(redraw_callback)
local timer = vim.loop.new_timer()

local function redraw()
  local now = vim.loop.now()
  if last_redraw == nil or now - last_redraw >= 100 then
    vim.loop.timer_stop(timer)
    redraw_callback(now)
  elseif not timer_going then
    timer_going = true
    vim.loop.timer_start(timer, 100 + last_redraw - now, 0, wrapped_redraw_callback)
  end
end

local function progress_callback(_, msg, ctx)
  local client_id = ctx.client_id

  ensure_init(messages, client_id, client_id)
  local val = msg.value
  if val.kind then
    if val.kind == "begin" then
      messages[client_id].progress[msg.token] = {
        title = val.title,
        message = val.message,
        percentage = val.percentage,
        spinner = 1,
      }
    elseif val.kind == "report" then
      messages[client_id].progress[msg.token].message = val.message
      messages[client_id].progress[msg.token].percentage = val.percentage
      messages[client_id].progress[msg.token].spinner = messages[client_id].progress[msg.token].spinner + 1
    elseif val.kind == "end" then
      if messages[client_id].progress[msg.token] == nil then
        if clients[client_id] ~= nil then
          vim.notify(
            "[lsp-status] Received `end` message with no corresponding `begin` from  " .. clients[client_id] .. "!",
            3
          )
        else
          vim.notify("[lsp-status] Received `end` message with no corresponding `begin` and nil client!", 3)
        end
      else
        messages[client_id].progress[msg.token].message = val.message
        messages[client_id].progress[msg.token].done = true
        messages[client_id].progress[msg.token].spinner = nil
      end
    end
  else
    table.insert(messages[client_id], { content = val, show_once = true, shown = 0 })
  end
  -- redraw()
end

local function register_progress()
  vim.lsp.handlers["$/progress"] = mk_handler(progress_callback)
end

register_progress()
