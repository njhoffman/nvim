
-- /home/nicholas/.local/share/nvim/runtime/lua/vim/lsp/rpc.lua

--- @private
--- @param handle_body fun(body: string)
--- @param on_exit? fun()
--- @param on_error fun(err: any)
function M.create_read_loop(handle_body, on_exit, on_error)
  local parse_chunk = coroutine.wrap(request_parser_loop) --[[@as fun(chunk: string?): string]]
  parse_chunk()
  return function(err, chunk)
    if err then
      on_error(err)
      return
    end

    if not chunk then
      if on_exit then
        on_exit()
      end
      return
    end

    while true do
      local body = parse_chunk(chunk)
      if body then
        handle_body(body)
        chunk = ''
      else
        break
      end
    end
  end
end

