
local timer = vim.loop.new_timer()
timer:start(1000, 0, vim.schedule_wrap(function()
  vim.api.nvim_command('echomsg "test"')
end))

-- (For one-shot timers, see |vim.defer_fn()|, which automatically adds the wrapping.)

-- Example: repeating timer
-- 1. Save this code to a file.
-- 2. Execute it with ":luafile %".

-- Create a timer handle (implementation detail: uv_timer_t).
local timer = vim.loop.new_timer()
local i = 0
-- Waits 1000ms, then repeats every 750ms until timer:close().
timer:start(1000, 750, function()
  print('timer invoked! i='..tostring(i))
  if i > 4 then
    timer:close()  -- Always close handles to avoid leaks.
  end
  i = i + 1
end)
print('sleeping');


-- Example: File-change detection                          *watch-file*
-- 1. Save this code to a file.
-- 2. Execute it with ":luafile %".
-- 3. Use ":Watch %" to watch any file.
-- 4. Try editing the file from another text editor.
-- 5. Observe that the file reloads in Nvim (because on_change() calls
--    |:checktime|).

local w = vim.loop.new_fs_event()
local function on_change(err, fname, status)
  -- Do work...
  vim.api.nvim_command('checktime')
  -- Debounce: stop/start.
  w:stop()
  watch_file(fname)
end
function watch_file(fname)
  local fullpath = vim.api.nvim_call_function(
    'fnamemodify', {fname, ':p'})
  w:start(fullpath, {}, vim.schedule_wrap(function(...)
    on_change(...) end))
end
vim.api.nvim_command(
  "command! -nargs=1 Watch call luaeval('watch_file(_A)', expand('<args>'))")


-- Example: TCP echo-server                                *tcp-server*
-- 1. Save this code to a file.
-- 2. Execute it with ":luafile %".
-- 3. Note the port number.
-- 4. Connect from any TCP client (e.g. "nc 0.0.0.0 36795"):

local function create_server(host, port, on_connect)
  local server = vim.loop.new_tcp()
  server:bind(host, port)
  server:listen(128, function(err)
    assert(not err, err)  -- Check for errors.
    local sock = vim.loop.new_tcp()
    server:accept(sock)  -- Accept client connection.
    on_connect(sock)  -- Start reading messages.
  end)
  return server
end
local server = create_server('0.0.0.0', 0, function(sock)
  sock:read_start(function(err, chunk)
    assert(not err, err)  -- Check for errors.
    if chunk then
      sock:write(chunk)  -- Echo received messages to the channel.
    else  -- EOF (stream closed).
      sock:close()  -- Always close handles to avoid leaks.
    end
  end)
end)

print('TCP echo-server listening on port: '..server:getsockname().port)
