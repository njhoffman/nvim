local state = require("alt.state")
local utils = require("alt.utils")

local getAltFile = function(name)
  name = name:gsub("^" .. vim.env.HOME, "~")
  local found = false
  for _, alt in ipairs(state.alts) do
    found = (alt[1] == name and alt[2][3]) or (alt[2] == name and alt[1][3]) or found
  end
  if found then
    return found[1], found[2]
  end
  return found
end

local clearAltFiles = function(files)
  local removed = {}
  files = type(files) == "string" and { files } or files
  if type(files) ~= "table" then
    removed = vim.deepcopy(state.alts)
    state.alts = {}
    return removed
  end
  for _, file in ipairs(files) do
    for i, alt in ipairs(state.alts) do
      if alt[1] == file or alt[2] == file then
        table.insert(removed, table.remove(state.alts, i))
      end
    end
  end
  return removed
end

local M = {}
function M.assignAltFile(reopen)
  reopen = reopen ~= false and true or false
  local curr_file = vim.fn.expand("%:p")
  local alt_file = vim.fn.expand("#:p")
  local removed = clearAltFiles({ curr_file, alt_file })
  table.insert(state.alts, { curr_file, alt_file, reopen })
  vim.dbglog("🪚 state: ", state.alts, removed)
end

function M.selectAltFile()
  local curr_file = vim.fn.expand("%:p")
  local open_files = {}
  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    table.insert(open_files, utils.formatPath(buf.name))
  end
  vim.ui.select(open_files, { prompt = "Select alternate file" }, function(new_alt)
    if new_alt then
      local removed = clearAltFiles({ curr_file, new_alt })
      table.insert(state.alts, { curr_file, new_alt })
    end
  end)
end

function M.lookupAltFile(ev)
  if not ev.match or ev.match == "" then
    return
  end
  local altFile, reopen = getAltFile(ev.match)
  vim.dbglog(ev.match, altFile)
  if altFile then
    local altOpen = false
    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      altOpen = buf.name == altFile or altOpen
    end
    local msg = "skipping unopened alt: "
      .. utils.formatPath(altFile)
      .. " for: "
      .. utils.formatPath(file)
    if reopen and not altOpen then
      msg = "setting unopened alt: "
        .. utils.formatPath(altFile)
        .. " for: "
        .. utils.formatPath(file)
      vim.fn.setreg("#", altFile)
    elseif not reopen and altOpen then
      msg = "setting opened alt: "
        .. utils.formatPath(altFile)
        .. " for: "
        .. utils.formatPath(file)
      vim.fn.setreg("#", altFile)
    end
    vim.dbglog(msg)
  end
end

function M.inspectState()
  utils.notify(vim.inspect(state))
end

return M
