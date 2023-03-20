local state = require("sidebar.state")
local config = require("sidebar.config")

local sidebar_cmds = {}
function sidebar_cmds.prev()
  state.update()
  local old_section = state.get_section()
  local prev_idx = old_section.idx - 1
  prev_idx = prev_idx < 1 and #state.available or prev_idx
  local prev_section = state.available[prev_idx]
  old_section.close()
  prev_section.open()
end

function sidebar_cmds.next()
  state.update()
  local old_section = state.get_section()
  local next_idx = old_section.idx + 1
  next_idx = next_idx > #state.available and 1 or next_idx
  local next_section = state.available[next_idx]
  old_section.close()
  next_section.open()
end

local commands = {}
function commands.open(name)
  state.update()
  local section = state.get_section(name)
  section.open()
  state.open = true
  config.refresh(state, sidebar_cmds)
end

function commands.close()
  local section = state.get_section()
  section.close()
  state.open = false
  config.refresh(state, sidebar_cmds)
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
