local state = require('sidebar.state')
local config = require('sidebar.config')

local sidebar_cmds = {}
function sidebar_cmds.prev()
  state.update()
  local prev_section = state.get_section()
  local next_idx = prev_section.idx - 1
  next_idx = next_idx < 1 and #state.available or next_idx
  local next_section = state.available[next_idx]
  state.current = next_section.name
  prev_section.close()
  next_section.open()
end

function sidebar_cmds.next()
  state.update()
  local prev_section = state.get_section()
  local next_idx = prev_section.idx + 1
  next_idx = next_idx > #state.available and 1 or next_idx
  local next_section = state.available[next_idx]
  state.current = next_section.name
  prev_section.close()
  next_section.open()
end

local commands = {}
function commands.open(name)
  state.update()
  if not state.open then
    local section = state.get_section(name)
    section.open()
    state.open = true
    -- TODO: calculate width
    -- state.width = config.get_width()
  end
  config.refresh(state.open, sidebar_cmds)
end

function commands.close()
  state.update()
  if state.open then
    local section = state.get_section()
    section.close()
    state.open = false
  end
  config.refresh(state.open, sidebar_cmds)
end

function commands.toggle(name)
  if state.open == false then
    commands.open(name)
  else
    commands.close()
  end
end

function commands.select()
  state.update()
end

return commands
