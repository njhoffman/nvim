local debounce_trailing = function(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(function()
        fn(unpack(argv))
      end)()
    end)
  end
end

local type_to_num = function(t)
  if t == 'E' then
    return 1
  end

  if t == 'W' then
    return 2
  end

  if t == 'I' then
    return 3
  end

  return 4
end
-- To get the number of lists in the quickfix and location list stack, you can
-- use the |getqflist()| and |getloclist()| functions respectively with the list
-- number set to the special value '$'. Examples:
--   echo getqflist({'nr' : '$'}).nr
--   echo getloclist(3, {'nr' : '$'}).nr
-- To get the number of the current list in the stack:
--   echo getqflist({'nr' : 0}).nr

return {
  debounce_trailing = debounce_trailing,
  type_to_num = type_to_num,
}
