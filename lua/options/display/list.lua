local state = require('options.state')

local list_options = function(arg_lead, buffer_local)
  local options = {}
  for key, info in pairs(state.registered_options) do
    arg_lead = arg_lead or "."
    if buffer_local == true and info.buffer_local == true then
      if string.match(key, "^" .. arg_lead) then
        table.insert(options, key)
      end
    elseif buffer_local ~= true and info.global == true then
      if string.match(key, "^" .. arg_lead) then
        table.insert(options, key)
      end
    end
  end
  return options
end

return list_options
