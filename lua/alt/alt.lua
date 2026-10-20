local state = require("alt.state")
local utils = require("alt.utils")

local M = {}

---shows info on alternate window/buffer/oldfile in that priority
---@param opts? { maxLen: number }
---@return string
function M.altStatusline(opts)
  opts = opts or {}
  local maxLen = opts.maxLen or 25

  local altPath = vim.fn.expand("#:p")
  local curPath = vim.fn.expand("%:p")
  local curFile = vim.fs.basename(curPath)
  local altFile = vim.fs.basename(altPath)

  local altBufNr = vim.fn.bufnr("#") ---@diagnostic disable-line: param-type-mismatch
  local specialFile = vim.api.nvim_buf_is_valid(altBufNr)
    and vim.api.nvim_get_option_value("buftype", { buf = altBufNr }) ~= ""
  local fileExists = vim.uv.fs_stat(altPath) ~= nil
  local hasAltFile = altFile ~= "" and altPath ~= curPath and (fileExists or specialFile)

  local name, icon
  if hasAltFile then
    -- icon
    local ext = vim.fn.expand("#:e")
    local altBufFt = vim.api.nvim_get_option_value("filetype", { buf = altBufNr }) ---@diagnostic disable-line: param-type-mismatch
    local ftOrExt = ext ~= "" and ext or altBufFt
    local ok, devicons = pcall(require, "nvim-web-devicons")
    icon = ok and devicons.get_icon(altFile, ftOrExt) or "#"

    -- name
    name = altFile
    if curFile == altFile then
      local altParent = vim.fs.basename(vim.fs.dirname(altPath))
      name = altParent .. "/" .. altFile
    end
  elseif utils.altOldfile() then
    local altOld = utils.altOldfile() ---@cast altOld string
    icon = "󰋚"
    name = vim.fs.basename(altOld)
  end

  -- truncate
  local nameNoExt = name:gsub("%.%w+$", "")
  if #nameNoExt > maxLen then
    local ext = name:match("%.%w+$")
    name = nameNoExt:sub(1, maxLen) .. "…" .. ext
  end
  return icon .. " " .. name
end

---switch to alternate buffer/oldfile (in that priority)
function M.gotoAltBuffer()
  if vim.bo.buftype == "terminal" then
    vim.fn.feedkeys("a", "n") -- enter terminal mode
    return
  elseif vim.bo.buftype ~= "" then
    return -- disable in other buffertypes
  end

  local altFile = vim.fn.expand("#:t")
  local altPath = vim.fn.expand("#:p")
  local curPath = vim.fn.expand("%:p")
  local altBufNr = vim.fn.bufnr("#") ---@diagnostic disable-line: param-type-mismatch
  local specialFile = vim.api.nvim_buf_is_valid(altBufNr)
    and vim.api.nvim_get_option_value("buftype", { buf = altBufNr }) ~= ""
  local fileExists = vim.uv.fs_stat(altPath) ~= nil
  local hasAltFile = altFile ~= "" and altPath ~= curPath and (fileExists or specialFile)

  if hasAltFile and (altPath ~= curPath) then
    vim.cmd("buffer #")
    -- cmd.buffer('#')
  elseif utils.altOldfile() then
    vim.cmd("edit " .. utils.altOldfile())
    -- cmd.edit(altOldfile())
  else
    utils.notify("Nothing to switch to.", "warn")
  end
end

function M.betterClose()
  if vim.bo.buftype ~= "" then
    pcall(vim.cmd.bwipeout, { bang = true })
    return
  end

  local absPath = vim.fn.expand("%:p")
  local fileExists = vim.uv.fs_stat(absPath) ~= nil
  if fileExists then
    vim.cmd("silent update " .. absPath)
  end

  -- close window
  if utils.numberOfWins() > 1 then
    vim.cmd.close()
    return
  end

  -- close buffers
  local openBuffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #openBuffers == 1 then
    utils.notify("Only one buffer open.", "trace")
    return
  end

  state.lastClosedBuffer = absPath -- save for undoing
  if #openBuffers == 2 then
    pcall(vim.cmd.bwipeout) -- cannot clear altfile otherwise :/
    return
  end

  local couldDelete = pcall(vim.cmd.bdelete)
  if not couldDelete then
    utils.notify("Could not delete buffer.", "warn")
    return
  end

  -- ensure new alt file points towards open, non-active buffer, or altoldfile
  local i = 0
  local newAltBuf = ""
  while true do
    i = i + 1
    if i > #openBuffers then
      newAltBuf = utils.altOldfile() or ""
      break
    end
    newAltBuf = openBuffers[i].name
    if newAltBuf ~= absPath and newAltBuf ~= absPath then
      break
    end
  end
  vim.fn.setreg("#", newAltBuf) -- empty string would set the altfile to the current buffer
end

---repons last closed buffer, similar to ctrl-shift-t in the browser. If no
---buffer has been closed this session, opens last oldfile
function M.reopenBuffer()
  -- cannot use purely oldfiles, since they are not updated after buffer closing
  vim.cmd.edit(state.lastClosedBuffer or utils.altOldfile())
end

return M
