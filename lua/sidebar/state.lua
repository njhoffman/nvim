local sections = require("sidebar.sections")

local state = {
  open = false,
  current = "",
  available = {},
}

function state.get_section(_name)
  local name = _name or state.current
  local match = false
  for _, section in ipairs(state.available) do
    match = section.name == name and section or match
  end
  if match == false then
    vim.notify("No available sidebar match: " .. name .. "\n" .. vim.inspect(state.available), 4)
  end
  return match
end

function state.update()
  state.available = {}
  local i = 1
  for name, section in pairs(sections) do
    section.name = name
    local enabled = section.enabled ~= false
    if type(section.enabled) == "function" then
      enabled = section.enabled()
    end
    if enabled then
      section.idx = i
      table.insert(state.available, section)
      i = i + 1
    end
  end
  if state.current == "" and #state.available > 0 then
    state.current = state.available[1].name
  end
end

return state
